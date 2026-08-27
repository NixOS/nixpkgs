{ lib, pkgs, ... }:

{
  name = "prometheus-ui";

  nodes = {
    browser =
      { config, pkgs, ... }:
      {
        virtualisation.memorySize = 1024 * 2;

        environment.systemPackages =
          let
            prometheusSeleniumScript =
              pkgs.writers.writePython3Bin "prometheus-selenium-script"
                {
                  libraries = with pkgs.python3Packages; [ selenium ];
                }
                ''
                  from selenium import webdriver
                  from selenium.webdriver.common.by import By
                  from selenium.webdriver.firefox.options import Options
                  from selenium.webdriver.support import expected_conditions as EC
                  from selenium.webdriver.support.ui import WebDriverWait

                  options = Options()
                  options.add_argument("--headless")
                  service = webdriver.FirefoxService(
                    executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501

                  driver = webdriver.Firefox(options=options, service=service)
                  driver.implicitly_wait(10)

                  driver.get("http://prometheus:9090/")
                  wait = WebDriverWait(driver, 60)

                  # There should have been a redirect
                  wait.until(EC.url_to_be("http://prometheus:9090/query"))

                  wait.until(EC.presence_of_element_located(
                    (By.CLASS_NAME, "mantine-AppShell-header")))
                  wait.until(EC.presence_of_element_located(
                    (By.CLASS_NAME, "mantine-AppShell-main")))

                  # Do a Prometheus query
                  query_box = driver.find_element(
                    By.XPATH, "//div[@role='textbox']")
                  query_box.click()
                  query_box.send_keys("up")

                  # Run query with execute button
                  driver.find_element(
                    By.XPATH, "//span[contains(text(),'Execute')]").click()

                  # Wait for query result table
                  wait.until(EC.presence_of_element_located(
                    (By.CLASS_NAME, "mantine-Table-tr")))

                  # Navigate to target health page
                  driver.find_element(
                    By.XPATH, "//span[text()='Status']").click()

                  driver.find_element(
                    By.LINK_TEXT, "Target health").click()

                  wait.until(EC.url_to_be("http://prometheus:9090/targets"))

                  # Click on the prometheus job dropdown button
                  driver.find_element(
                    By.CLASS_NAME, "mantine-Accordion-chevron").click()

                  wait.until(EC.presence_of_element_located(
                    (By.CSS_SELECTOR, "div[class^='_healthOk']")))

                  targets_errored = len(driver.find_elements(
                    By.CSS_SELECTOR, "div[class^='_healthErr']"))
                  assert targets_errored == 0

                  # Go back to homepage
                  driver.find_element(
                    By.XPATH, "//span[text()='Query']").click()

                  # Navigate to build info section and verify correct version
                  # number shown
                  driver.find_element(
                    By.XPATH, "//span[text()='Status']").click()

                  driver.find_element(
                    By.LINK_TEXT, "Runtime & build information").click()

                  wait.until(EC.url_to_be("http://prometheus:9090/status"))

                  # Find table and verify version
                  wait.until(EC.text_to_be_present_in_element(
                    (By.XPATH,
                     "//tr[th[text()='version']]/td"),
                    "${pkgs.prometheus.version}"))

                  driver.close()
                '';
          in
          with pkgs;
          [
            curl
            firefox-unwrapped
            geckodriver
            prometheusSeleniumScript
          ];
      };

    prometheus =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [ config.services.prometheus.port ];

        services.prometheus = {
          enable = true;
          globalConfig.scrape_interval = "2s";
          scrapeConfigs = [
            {
              job_name = "prometheus";
              static_configs = [
                {
                  targets = [
                    "prometheus:${toString config.services.prometheus.port}"
                  ];
                }
              ];
            }
          ];
        };
      };
  };

  testScript = ''
    prometheus.wait_for_unit("prometheus")
    prometheus.wait_for_open_port(9090)
    prometheus.wait_until_succeeds("curl -sSf http://localhost:9090/-/healthy")

    browser.systemctl("start network-online.target")
    browser.wait_for_unit("network-online.target")

    browser.succeed("curl -kLs http://prometheus:9090/query | grep 'Prometheus Time Series Collection and Processing Server'")

    # Ensure the application is actually rendered by the Javascript
    browser.succeed("PYTHONUNBUFFERED=1 prometheus-selenium-script")
  '';
}
