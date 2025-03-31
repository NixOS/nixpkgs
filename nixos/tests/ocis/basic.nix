{
  name,
  pkgs,
  testBase,
  system,
  ...
}:

with import ../../lib/testing-python.nix { inherit system pkgs; };
runTest (
  { config, lib, ... }:
  {
    inherit name;
    meta = with lib.maintainers; {
      maintainers = [
        bhankas
        ramblurr
      ];
    };

    imports = [ testBase ];

    nodes = {
      ocis =
        { pkgs, ... }:
        let

          testRunner =
            pkgs.writers.writePython3Bin "test-runner"
              {
                libraries = [ pkgs.python3Packages.selenium ];
                flakeIgnore = [ "E501" ];
              }
              ''
                import sys
                from selenium.webdriver.common.by import By
                from selenium.webdriver import Firefox
                from selenium.webdriver.firefox.options import Options
                from selenium.webdriver.support.ui import WebDriverWait
                from selenium.webdriver.support import expected_conditions as EC

                options = Options()
                options.add_argument('--headless')
                driver = Firefox(options=options)

                user = sys.argv[1]
                password = sys.argv[2]
                driver.implicitly_wait(20)
                driver.get('https://ocis:9200/login')
                wait = WebDriverWait(driver, 10)
                wait.until(EC.title_contains("Sign in"))
                driver.find_element(By.XPATH, '//*[@id="oc-login-username"]').send_keys(user)
                driver.find_element(By.XPATH, '//*[@id="oc-login-password"]').send_keys(password)
                driver.find_element(By.XPATH, '//*[@id="root"]//button').click()
                wait.until(EC.title_contains("Personal"))
                print("Test succeeded")
              '';
        in

        {
          virtualisation.memorySize = 2048;
          environment.systemPackages = [
            pkgs.firefox-unwrapped
            pkgs.geckodriver
            testRunner
          ];
          networking.firewall.allowedTCPPorts = [ 9200 ];
          # if you do this in production, dont put secrets in this file because it will be written to the world readable nix store
          environment.etc."ocis/ocis.env".text = ''
            ADMIN_PASSWORD=${config.adminPassword}
            IDM_CREATE_DEMO_USERS=true
          '';

          # if you do this in production, dont put secrets in this file because it will be written to the world readable nix store
          environment.etc."ocis/config/ocis.yaml".text = builtins.readFile ./config.yaml;

          services.ocis = {
            enable = true;
            configDir = "/etc/ocis/config";
            environment = {
              OCIS_INSECURE = "true";
              PROXY_ENABLE_BASIC_AUTH = "true";
              PROXY_HTTP_ADDR = "[::]:9200";
              OCIS_URL = "https://ocis:9200";
            };
            environmentFile = "/etc/ocis/ocis.env";
          };
        };
    };
    test-helpers.extraTests =
      { ... }:
      ''
        with subtest("use the web interface to log in with a demo user"):
            ocis.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner ${config.demoUser} ${config.demoPassword}")

        with subtest("use the web interface to log in with the provisioned admin user"):
            ocis.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner ${config.adminUser} ${config.adminPassword}")
      '';

  }
)
