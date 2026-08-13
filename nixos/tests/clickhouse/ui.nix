{
  lib,
  pkgs,
  package,
  ...
}:

{
  name = "clickhouse-ui";

  nodes = {
    browser =
      {
        config,
        pkgs,
        ...
      }:
      {
        virtualisation.memorySize = 1024 * 2;

        environment.systemPackages =
          let
            clickhouseSeleniumScript =
              pkgs.writers.writePython3Bin "clickhouse-selenium-script"
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
                  service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501

                  driver = webdriver.Firefox(options=options, service=service)
                  driver.implicitly_wait(10)
                  driver.get("http://clickhouse:8123/play")

                  wait = WebDriverWait(driver, 60)

                  wait.until(EC.presence_of_element_located(
                    (By.ID, "query_div")))

                  version = "${lib.strings.replaceStrings [ "-stable" "-lts" ] [ "" "" ] package.version}"
                  wait.until(EC.text_to_be_present_in_element(
                    (By.XPATH, "//span[@id='server_info']"), version))

                  # Determine if a shadow DOM is used for query-result and
                  # query-progress
                  result_els = driver.find_elements(By.ID, "query-result")
                  uses_shadow = len(result_els) > 0
                  if uses_shadow:
                      result_shadow = result_els[0].shadow_root
                      progress_shadow = driver.find_element(
                        By.ID, "query-progress").shadow_root


                  def find_rows():
                      root = result_shadow if uses_shadow else driver
                      return root.find_elements(
                        By.CSS_SELECTOR, ".row-number")


                  def find_check_mark():
                      root = progress_shadow if uses_shadow else driver
                      return root.find_elements(
                        By.CSS_SELECTOR, "#check-mark")


                  # Shouldn't show before query done
                  assert len(find_rows()) == 0

                  query_box = driver.find_element(
                    By.XPATH, "//textarea[@id='query']")
                  query_box.click()
                  query_box.send_keys("SELECT 1")

                  driver.find_element(
                    By.XPATH, "//button[@id='run']").click()

                  # Wait for query to complete
                  WebDriverWait(driver, 60).until(
                    lambda d: len(find_check_mark()) > 0)

                  # Wait for results to render
                  WebDriverWait(driver, 60).until(
                    lambda d: len(find_rows()) > 0)

                  driver.close()
                '';
          in
          with pkgs;
          [
            curl
            firefox-unwrapped
            geckodriver
            clickhouseSeleniumScript
          ];
      };

    clickhouse =
      { config, pkgs, ... }:
      {
        networking.firewall.allowedTCPPorts = [
          8123
          9000
        ];

        environment.etc = {
          "clickhouse-server/config.d/listen.xml".text = ''
            <clickhouse>
              <listen_host>::</listen_host>
            </clickhouse>
          '';
        };

        services.clickhouse = {
          enable = true;
          inherit package;
        };
      };
  };

  testScript = ''
    clickhouse.wait_for_unit("clickhouse")
    clickhouse.wait_for_open_port(8123)
    clickhouse.wait_for_open_port(9000)

    browser.systemctl("start network-online.target")
    browser.wait_for_unit("network-online.target")

    browser.succeed("curl -kLs http://clickhouse:8123/play | grep 'ClickHouse Query'")

    # Ensure the application is actually rendered by the Javascript
    browser.succeed("PYTHONUNBUFFERED=1 clickhouse-selenium-script")
  '';
}
