{
  lib,
  writers,
  python3Packages,
  geckodriver,
}:
let
  user = "admin";
  domain = "localhost";
  url = "http://${domain}";
  email = "${user}@${domain}";
  password = "0123456789";
in
writers.writePython3Bin "selenium-test"
  {
    libraries = with python3Packages; [ selenium ];
    flakeIgnore = [
      "E501" # line too long
    ];
  }
  # python
  ''
    from selenium import webdriver
    from selenium.webdriver.common.by import By
    from selenium.webdriver.firefox.options import Options
    from selenium.webdriver.support.ui import WebDriverWait
    from selenium.webdriver.support import expected_conditions as EC


    def log(msg):
        from sys import stderr
        print(f"[*] {msg}", file=stderr)


    log("Initializing")

    options = Options()
    options.add_argument("--headless")

    service = webdriver.FirefoxService(executable_path="${lib.getExe geckodriver}")  # noqa: E501
    driver = webdriver.Firefox(options=options, service=service)

    driver.implicitly_wait(60)
    driver.set_page_load_timeout(90)

    log("Opening sign up page")
    driver.get("${url}/signup")


    def wait_elem(by, query, timeout=60):
        wait = WebDriverWait(driver, timeout)
        wait.until(EC.presence_of_element_located((by, query)))


    def wait_title_contains(title, timeout=60):
        wait = WebDriverWait(driver, timeout)
        wait.until(EC.title_contains(title))


    def find_element(by, query):
        return driver.find_element(by, query)


    def set_value(elem, value):
        script = 'arguments[0].value = arguments[1]'
        return driver.execute_script(script, elem, value)


    log("Waiting for the sign up page to load")

    wait_title_contains("Sign up")
    wait_elem(By.CSS_SELECTOR, 'input#signup-form_email_0_email_address')

    log("Sign up page loaded!")

    log("Filling out email")
    input_login = find_element(By.CSS_SELECTOR, 'input#signup-form_email_0_email_address')
    set_value(input_login, "${email}")

    log("Filling out password")
    input_password = find_element(By.CSS_SELECTOR, 'input#signup-form_credential_0_password')
    set_value(input_password, "${password}")
    input_password = find_element(By.CSS_SELECTOR, 'input#signup-form_credential_0_password_confirmation')
    set_value(input_password, "${password}")

    log("Submitting credentials for login")
    driver.find_element(By.CSS_SELECTOR, 'button#signup_submit').click()

    log("Waiting to create new personal profile")
    wait_title_contains("Create new personal profile")
    input_name = find_element(By.CSS_SELECTOR, 'input#create-user-form_profile_0_name')
    set_value(input_name, "${user}")

    log("Create new personal profile")
    input_username = find_element(By.CSS_SELECTOR, 'input#create-user-form_character_0_username')
    set_value(input_username, "${user}")
    if driver.find_element(By.CSS_SELECTOR, 'input[name=undiscoverable]').is_selected():
        driver.find_element(By.CSS_SELECTOR, 'input[name=undiscoverable]').click()
    if driver.find_element(By.CSS_SELECTOR, 'input[name=unindexable]').is_selected():
        driver.find_element(By.CSS_SELECTOR, 'input[name=unindexable]').click()
    if not driver.find_element(By.CSS_SELECTOR, 'input#create-user-code-of-conduct-consent').is_selected():
        driver.find_element(By.CSS_SELECTOR, 'input#create-user-code-of-conduct-consent').click()

    # Workaround "Welcome back!" hiding the "Create" button that needs to be click()ed
    # Documentation: https://www.selenium.dev/documentation/webdriver/troubleshooting/errors/#elementclickinterceptedexception
    welcome = driver.find_element(By.CSS_SELECTOR, 'div[data-id=flash_info]')
    driver.execute_script("arguments[0].remove();", welcome)

    driver.find_element(By.CSS_SELECTOR, 'button[type=submit]').click()

    log("Waiting Home page")
    wait_title_contains("Home")


    driver.close()
    driver.quit()
  ''
