{ lib, ... }:
let
  servicePort = 9090;
in
{
  name = "Basic Omnom Test";
  meta = {
    maintainers = lib.teams.ngi.members;
  };

  interactive.sshBackdoor.enable = true;

  nodes = {
    server =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        services.omnom = {
          enable = true;
          openFirewall = true;

          port = servicePort;

          settings = {
            app = {
              disable_signup = false; # restrict CLI user-creation
              results_per_page = 50;
            };
            server.address = "0.0.0.0:${toString servicePort}";
          };
        };

        environment.systemPackages =
          let
            addon = "${pkgs.omnom}/share/addons/omnom_ext_firefox.zip";
            seleniumScript =
              pkgs.writers.writePython3Bin "selenium-script"
                {
                  libraries = with pkgs.python3Packages; [ selenium ];
                  flakeIgnore = [ "E501" ];
                }
                # python
                ''
                  import re
                  import sys
                  from selenium.webdriver import Firefox, FirefoxService
                  from selenium.webdriver.common.by import By
                  from selenium.webdriver.firefox.firefox_profile import FirefoxProfile
                  from selenium.webdriver.firefox.options import Options
                  from selenium.webdriver.support import expected_conditions as EC
                  from selenium.webdriver.support.ui import WebDriverWait

                  uuid = "2b09138b-b2a5-4e14-b938-4e8ff510941d"

                  service = FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")
                  profile = FirefoxProfile()
                  # https://github.com/mozilla/geckodriver/issues/1996
                  # Allocate a UUID for accessing addon pages later
                  # the key is specified in manifest.json of the addon
                  profile.set_preference(
                      "extensions.webextensions.uuids",
                      '{"{f0bca7ce-0cda-41dc-9ea8-126a50fed280}": "' + uuid + '"}',
                  )
                  options = Options()
                  options.add_argument("--headless")
                  options.profile = profile
                  driver = Firefox(service=service, options=options)
                  # use True for https://github.com/mozilla/geckodriver/issues/1912
                  addon = driver.install_addon("${addon}", True)

                  # log in
                  driver.get(sys.argv[1])
                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.url_changes(sys.argv[1]))

                  # set up the addon
                  driver.get(f"moz-extension://{uuid}/options.html")
                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, 'input[type="submit"]')))

                  form = driver.find_element(By.CSS_SELECTOR, "form")
                  token = form.find_element(By.CSS_SELECTOR, 'input[name="token"]')
                  url = form.find_element(By.CSS_SELECTOR, 'input[name="url"]')
                  submit = form.find_element(By.CSS_SELECTOR, 'input[type="submit"]')

                  token.send_keys(sys.argv[2])
                  url.send_keys(sys.argv[3])
                  submit.click()

                  # take snapshot
                  # This will snapshot the popup page
                  driver.get(f"moz-extension://{uuid}/popup.html")
                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, 'input[type="submit"]')))

                  form = driver.find_element(By.CSS_SELECTOR, "form")
                  submit = form.find_element(By.CSS_SELECTOR, 'input[type="submit"]')

                  submit.click()

                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, '#status.success')))

                  driver.get(f"{sys.argv[3]}")
                  wait = WebDriverWait(driver, 10)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, ".content")))

                  driver.save_full_page_screenshot("home.png")

                  driver.get(f"{sys.argv[3]}/bookmark?id=1")
                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, ".snapshot__link > div > a")))

                  snapshot = driver.find_element(By.CSS_SELECTOR, ".snapshot__link > div > a")

                  snapshot.click()

                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, ".snapshot-iframe")))

                  driver.save_full_page_screenshot("screenshot.png")

                  match = re.search(r"sid=([0-9a-fA-F]+)", driver.current_url)
                  assert match is not None, "sid not found"
                  sid = match[1]

                  driver.get(f"{sys.argv[3]}/snapshot_details?sid={sid}")
                  wait = WebDriverWait(driver, 3)
                  wait.until(EC.visibility_of_element_located((By.CSS_SELECTOR, ".content")))

                  driver.save_full_page_screenshot("snapshot_details.png")

                  driver.quit()
                '';
          in
          [
            pkgs.firefox-unwrapped
            pkgs.geckodriver
            seleniumScript
            (pkgs.python3.withPackages (ps: with ps; [ selenium ]))
          ];
      };
  };

  testScript =
    { nodes, ... }:
    # python
    ''
      import re

      service_url = "http://127.0.0.1:${toString servicePort}"

      server.start()
      server.wait_for_unit("omnom.service")
      server.wait_for_open_port(${toString servicePort})
      server.succeed(f"curl -sf {service_url}")

      output = server.succeed("omnom create-user user user@example.com")
      match = re.search(r"Visit (.+?) to sign in", output)
      assert match is not None, "Login URL not found"
      login_url = match[1].replace("0.0.0.0", "127.0.0.1")

      output = server.succeed("omnom create-token user addon")
      match = re.search(r"Token (.+?) created", output)
      assert match is not None, "Addon token not found"
      token = match[1]

      server.succeed(f"selenium-script 'http://{login_url}' '{token}' '{service_url}'")

      server.copy_from_vm("home.png", ".")
      server.copy_from_vm("screenshot.png", ".")
      server.copy_from_vm("snapshot_details.png", ".")
    '';
}
