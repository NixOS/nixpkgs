import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "filesender";
    meta = {
      maintainers = with lib.maintainers; [ nhnn ];
      broken = pkgs.stdenv.hostPlatform.isAarch64; # selenium.common.exceptions.WebDriverException: Message: Unsupported platform/architecture combination: linux/aarch64
    };

    nodes.filesender =
      { ... }:
      let
        format = pkgs.formats.php { };
      in
      {
        networking.firewall.allowedTCPPorts = [ 80 ];

        services.filesender.enable = true;
        services.filesender.localDomain = "filesender";
        services.filesender.settings = {
          auth_sp_saml_authentication_source = "default";
          auth_sp_saml_uid_attribute = "uid";
          storage_filesystem_path = "/tmp";
          site_url = "http://filesender";
          force_ssl = false;
          admin = "";
          admin_email = "admin@localhost";
          email_reply_to = "noreply@localhost";
        };
        services.simplesamlphp.filesender = {
          settings = {
            baseurlpath = "http://filesender/saml";
            "module.enable".exampleauth = true;
          };
          authSources = {
            admin = [ "core:AdminPassword" ];
            default = format.lib.mkMixedArray [ "exampleauth:UserPass" ] {
              "user:password" = {
                uid = [ "user" ];
                cn = [ "user" ];
                mail = [ "user@nixos.org" ];
              };
            };
          };
        };
      };

    nodes.client =
      {
        pkgs,
        nodes,
        ...
      }:
      let
        filesenderIP = (builtins.head (nodes.filesender.networking.interfaces.eth1.ipv4.addresses)).address;
      in
      {
        networking.hosts.${filesenderIP} = [ "filesender" ];

        environment.systemPackages =
          let
            username = "user";
            password = "password";
            browser-test =
              pkgs.writers.writePython3Bin "browser-test"
                {
                  libraries = [ pkgs.python3Packages.selenium ];
                  flakeIgnore = [
                    "E124"
                    "E501"
                  ];
                }
                ''
                  from selenium.webdriver.common.by import By
                  from selenium.webdriver import Firefox
                  from selenium.webdriver.firefox.options import Options
                  from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
                  from selenium.webdriver.firefox.service import Service
                  from selenium.webdriver.support.ui import WebDriverWait
                  from selenium.webdriver.support import expected_conditions as EC
                  from subprocess import STDOUT
                  import string
                  import random
                  import logging
                  import time
                  selenium_logger = logging.getLogger("selenium")
                  selenium_logger.setLevel(logging.DEBUG)
                  selenium_logger.addHandler(logging.StreamHandler())
                  profile = FirefoxProfile()
                  profile.set_preference("browser.download.folderList", 2)
                  profile.set_preference("browser.download.manager.showWhenStarting", False)
                  profile.set_preference("browser.download.dir", "/tmp/firefox")
                  profile.set_preference("browser.helperApps.neverAsk.saveToDisk", "text/plain;text/txt")
                  options = Options()
                  options.profile = profile
                  options.add_argument('--headless')
                  service = Service(log_output=STDOUT)
                  driver = Firefox(options=options)
                  driver.set_window_size(1024, 768)
                  driver.implicitly_wait(30)
                  driver.get('http://filesender/')
                  wait = WebDriverWait(driver, 20)
                  wait.until(EC.title_contains("FileSender"))
                  driver.find_element(By.ID, "btn_logon").click()
                  wait.until(EC.title_contains("Enter your username and password"))
                  driver.find_element(By.ID, 'username').send_keys(
                      '${username}'
                  )
                  driver.find_element(By.ID, 'password').send_keys(
                      '${password}'
                  )
                  driver.find_element(By.ID, "submit_button").click()
                  wait.until(EC.title_contains("FileSender"))
                  wait.until(EC.presence_of_element_located((By.ID, "topmenu_logoff")))
                  test_string = "".join(random.choices(string.ascii_uppercase + string.digits, k=20))
                  with open("/tmp/test_file.txt", "w") as file:
                      file.write(test_string)
                  driver.find_element(By.ID, "files").send_keys("/tmp/test_file.txt")
                  time.sleep(2)
                  driver.find_element(By.CSS_SELECTOR, '.start').click()
                  wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".download_link")))
                  download_link = driver.find_element(By.CSS_SELECTOR, '.download_link > textarea').get_attribute('value').strip()
                  driver.get(download_link)
                  wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".download")))
                  driver.find_element(By.CSS_SELECTOR, '.download').click()
                  wait.until(EC.presence_of_element_located((By.CSS_SELECTOR, ".ui-dialog-buttonset > button:nth-child(2)")))
                  driver.find_element(By.CSS_SELECTOR, ".ui-dialog-buttonset > button:nth-child(2)").click()
                  driver.close()
                  driver.quit()
                '';
          in
          [
            pkgs.firefox-unwrapped
            pkgs.geckodriver
            browser-test
          ];
      };

    testScript = ''
      start_all()
      filesender.wait_for_file("/run/phpfpm/filesender.sock")
      filesender.wait_for_open_port(80)
      if "If you have received an invitation to access this site as a guest" not in client.wait_until_succeeds("curl -sS -f http://filesender"):
        raise Exception("filesender returned invalid html")
      client.succeed("browser-test")
    '';
  }
)
