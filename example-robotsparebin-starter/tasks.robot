# -*- coding: utf-8 -*-
# ## Beginners' course - starter files
#
# This example is the starting point of our <a href="https://robocorp.com/docs/courses/beginners-course">beginners' course</a>.
#
# Take the course to learn how to turn this into a complete and useful robot!
#

*** Settings ***
Documentation     Starter robot for the Beginners' course.
Library           RPA.Browser.Selenium
Library           RPA.HTTP
Library           RPA.Excel.Files
Library           RPA.PDF
Library           RPA.Robocloud.Secrets

*** Keywords ***
Open Intranet Website
    Open Available Browser    https://robotsparebinindustries.com/

*** Keywords ***
Log In
    ${secret}=  Get Secret    robotsparebin
    Input Text    id:username   ${secret}[username]
    Input Password   id:password   ${secret}[password]
    Submit Form
    Wait Until Page Contains Element    id:sales-form


*** Keywords ***
Download The Excel File
    Download    https://robotsparebinindustries.com/SalesData.xlsx    overwrite=True

*** Keywords ***
Fill The Form Using The Data From The Excel File
    Open Workbook    SalesData.xlsx
    ${sales_reps}=   Read Worksheet As Table    header=True
    Close Workbook
    FOR  ${sales_rep}    IN  @{sales_reps}
        Fill And Submit The Form for One Person   ${sales_rep}
    END

*** Keywords ***
Fill And Submit The Form for One Person
    [Arguments]    ${sales_rep}
    Input Text    firstname    ${sales_rep}[First Name]
    Input Text    lastname    ${sales_rep}[Last Name]
    Input Text    salesresult   ${sales_rep}[Sales]
    ${target_as_string}=    Convert To String   ${sales_rep}[Sales Target]
    Select From List By Value    salestarget    ${target_as_string}
    Click Button    Submit

*** Keywords ***
Collect The Results
      Screenshot    css:div.sales-summary    ${CURDIR}${/}output${/}sales_summary.png


*** Keywords ***
Print PDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${CURDIR}${/}output${/}sales_results.pdf

*** Keywords ***
Logout and Close
    Click Button    id:logout
    Close Browser

*** Tasks ***
Insert the sales data for the week and expro it as a PDF
    Open Intranet Website
    Log In
    Download The Excel File
    Fill The Form Using The Data From The Excel File
    Collect The Results
    Print PDF
    [Teardown]  Logout and Close

