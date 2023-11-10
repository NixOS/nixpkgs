{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

# These tests will:
#  * Set up a vaultwarden server
#  * Have Firefox use the web vault to create an account, log in, and save a password to the valut
#  * Have the bw cli log in and read that password from the vault
#
# Note that Firefox must be on the same machine as the server for WebCrypto APIs to be available (or HTTPS must be configured)
#
# The same tests should work without modification on the official bitwarden server, if we ever package that.

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;
let
  backends = [ "sqlite" "mysql" "postgresql" ];

  dbPassword = "please_dont_hack";

  userEmail = "meow@example.com";
  userPassword = "also_super_secret_ZJWpBKZi668QGt"; # Must be complex to avoid interstitial warning on the signup page

  storedPassword = "seeeecret";

  makeVaultwardenTest = backend: makeTest {
    name = "vaultwarden-${backend}";
    meta = {
      maintainers = with pkgs.lib.maintainers; [ jjjollyjim ];
    };

    nodes = {
      server = { pkgs, ... }:
        let backendConfig = {
          mysql = {
            services.mysql = {
              enable = true;
              initialScript = pkgs.writeText "mysql-init.sql" ''
                CREATE DATABASE bitwarden;
                CREATE USER 'bitwardenuser'@'localhost' IDENTIFIED BY '${dbPassword}';
                GRANT ALL ON `bitwarden`.* TO 'bitwardenuser'@'localhost';
                FLUSH PRIVILEGES;
              '';
              package = pkgs.mariadb;
            };

            services.vaultwarden.config.databaseUrl = "mysql://bitwardenuser:${dbPassword}@localhost/bitwarden";

            systemd.services.vaultwarden.after = [ "mysql.service" ];
          };

          postgresql = {
            services.postgresql = {
              enable = true;
              initialScript = pkgs.writeText "postgresql-init.sql" ''
                CREATE USER bitwardenuser WITH PASSWORD '${dbPassword}';
                CREATE DATABASE bitwarden WITH OWNER bitwardenuser;
              '';
            };

            services.vaultwarden.config.databaseUrl = "postgresql://bitwardenuser:${dbPassword}@localhost/bitwarden";

            systemd.services.vaultwarden.after = [ "postgresql.service" ];
          };

          sqlite = { };
        };
        in
        mkMerge [
          backendConfig.${backend}
          {
            services.vaultwarden = {
              enable = true;
              dbBackend = backend;
              config = {
                rocketAddress = "0.0.0.0";
                rocketPort = 80;
              };
            };

            networking.firewall.allowedTCPPorts = [ 80 ];

            environment.systemPackages =
              let
                testRunner = pkgs.writers.writePython3Bin "test-runner"
                  {
                    libraries = [ pkgs.python3Packages.selenium ];
                    flakeIgnore = [
                      "E501"
                    ];
                  } ''

                  from selenium.webdriver.common.by import By
                  from selenium.webdriver import Firefox
                  from selenium.webdriver.firefox.options import Options
                  from selenium.webdriver.support.ui import WebDriverWait
                  from selenium.webdriver.support import expected_conditions as EC

                  options = Options()
                  options.add_argument('--headless')
                  driver = Firefox(options=options)

                  driver.implicitly_wait(20)
                  driver.get('http://localhost/#/register')

                  wait = WebDriverWait(driver, 10)

                  wait.until(EC.title_contains("Create account"))

                  driver.find_element(By.CSS_SELECTOR, 'input#register-form_input_email').send_keys(
                      '${userEmail}'
                  )
                  driver.find_element(By.CSS_SELECTOR, 'input#register-form_input_name').send_keys(
                      'A Cat'
                  )
                  driver.find_element(By.CSS_SELECTOR, 'input#register-form_input_master-password').send_keys(
                      '${userPassword}'
                  )
                  driver.find_element(By.CSS_SELECTOR, 'input#register-form_input_confirm-master-password').send_keys(
                      '${userPassword}'
                  )
                  if driver.find_element(By.CSS_SELECTOR, 'input#checkForBreaches').is_selected():
                      driver.find_element(By.CSS_SELECTOR, 'input#checkForBreaches').click()

                  driver.find_element(By.XPATH, "//button[contains(., 'Create account')]").click()

                  wait.until_not(EC.title_contains("Create account"))

                  driver.find_element(By.XPATH, "//button[contains(., 'Continue')]").click()

                  driver.find_element(By.CSS_SELECTOR, 'input#login_input_master-password').send_keys(
                      '${userPassword}'
                  )
                  driver.find_element(By.XPATH, "//button[contains(., 'Log in')]").click()

                  wait.until(EC.title_contains("Vaults"))

                  driver.find_element(By.XPATH, "//button[contains(., 'New item')]").click()

                  driver.find_element(By.CSS_SELECTOR, 'input#name').send_keys(
                      'secrets'
                  )
                  driver.find_element(By.CSS_SELECTOR, 'input#loginPassword').send_keys(
                      '${storedPassword}'
                  )

                  driver.find_element(By.XPATH, "//button[contains(., 'Save')]").click()
                '';
              in
              [ pkgs.firefox-unwrapped pkgs.geckodriver testRunner ];

          }
        ];

      client = { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.bitwarden-cli ];
        };
    };

    testScript = ''
      start_all()
      server.wait_for_unit("vaultwarden.service")
      server.wait_for_open_port(80)

      with subtest("configure the cli"):
          client.succeed("bw --nointeraction config server http://server")

      with subtest("can't login to nonexistent account"):
          client.fail(
              "bw --nointeraction --raw login ${userEmail} ${userPassword}"
          )

      with subtest("use the web interface to sign up, log in, and save a password"):
          server.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner")

      with subtest("log in with the cli"):
          key = client.succeed(
              "bw --nointeraction --raw login ${userEmail} ${userPassword}"
          ).strip()

      with subtest("sync with the cli"):
          client.succeed(f"bw --nointeraction --raw --session {key} sync -f")

      with subtest("get the password with the cli"):
          password = client.succeed(
              f"bw --nointeraction --raw --session {key} list items | ${pkgs.jq}/bin/jq -r .[].login.password"
          )
          assert password.strip() == "${storedPassword}"
    '';
  };
in
builtins.listToAttrs (
  map
    (backend: { name = backend; value = makeVaultwardenTest backend; })
    backends
)
