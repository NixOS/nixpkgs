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
                  from selenium.webdriver.support.relative_locator import locate_with
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
                  url = driver.current_url
                  assert url == "http://prometheus:9090/query"

                  assert len(driver.find_elements(
                    By.CLASS_NAME, "mantine-AppShell-header")) > 0
                  assert len(driver.find_elements(
                    By.CLASS_NAME, "mantine-AppShell-main")) > 0

                  # Do a Prometheus query
                  query_box = driver.find_element(
                    By.XPATH, "//div[@role='textbox']")
                  query_box.click()
                  query_box.send_keys("up")

                  # Run query with execute button
                  driver.find_element(
                    By.XPATH, "//span[contains(text(),'Execute')]").click()

                  # Find query result table
                  table_tr_elements = driver.find_elements(
                    By.CLASS_NAME, "mantine-Table-tr")
                  assert len(table_tr_elements) == 1

                  # Navigate to target health page
                  driver.find_element(
                    By.XPATH, "//span[text()='Status']").click()

                  driver.find_element(
                    By.LINK_TEXT, "Target health").click()

                  url = driver.current_url
                  assert url == "http://prometheus:9090/targets"

                  # Click on the prometheus job dropdown button
                  prometheus_job_dropdown = driver.find_element(
                    By.CLASS_NAME, "mantine-Accordion-chevron").click()

                  targets_healthy = len(driver.find_elements(
                    By.CSS_SELECTOR, "div[class^='_healthOk']"))
                  assert targets_healthy == 1

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

                  url = driver.current_url
                  assert url == "http://prometheus:9090/status"

                  # Find table
                  version_th_element = driver.find_element(
                    By.XPATH, "//th[text()='version']")
                  version_td_element = driver.find_element(
                    locate_with(By.TAG_NAME, "td").near(version_th_element))
                  assert version_td_element.text == "${pkgs.prometheus.version}"

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
