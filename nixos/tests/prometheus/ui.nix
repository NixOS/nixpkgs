{ lib, pkgs, ... }:

{
  name = "prometheus-ui";

  nodes = {
    browser =
      { config, pkgs, ... }:
      {
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
                  from selenium.webdriver.support.ui import WebDriverWait

                  options = Options()
                  options.add_argument("--headless")
                  service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501

                  driver = webdriver.Firefox(options=options, service=service)
                  driver.implicitly_wait(10)
                  driver.get("http://prometheus:9090/")

                  wait = WebDriverWait(driver, 60)

                  assert len(driver.find_elements(By.CLASS_NAME, "mantine-AppShell-header")) > 0  # noqa: E501
                  assert len(driver.find_elements(By.CLASS_NAME, "mantine-AppShell-main")) > 0  # noqa: E501

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
                    "prometheus1:${toString config.services.prometheus.port}"
                    "prometheus2:${toString config.services.prometheus.port}"
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
