import ./make-test-python.nix ({ pkgs, lib, ... }:
{
  name = "castopod";
  meta = with lib.maintainers; {
    maintainers = [ alexoundos misuzu ];
  };
  nodes.castopod = { nodes, ... }: {
    networking.firewall.allowedTCPPorts = [ 80 ];
    networking.extraHosts = ''
      127.0.0.1 castopod.example.com
    '';
    services.castopod = {
      enable = true;
      database.createLocally = true;
      localDomain = "castopod.example.com";
    };
    environment.systemPackages =
      let
        username = "admin";
        email = "admin@castood.example.com";
        password = "v82HmEp5";
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
          try:
              driver.implicitly_wait(20)
              driver.get('http://castopod.example.com/cp-install')

              wait = WebDriverWait(driver, 10)

              wait.until(EC.title_contains("installer"))

              driver.find_element(By.CSS_SELECTOR, '#username').send_keys(
                  '${username}'
              )
              driver.find_element(By.CSS_SELECTOR, '#email').send_keys(
                  '${email}'
              )
              driver.find_element(By.CSS_SELECTOR, '#password').send_keys(
                  '${password}'
              )
              driver.find_element(By.XPATH, "//button[contains(., 'Finish install')]").click()

              wait.until(EC.title_contains("Auth"))

              driver.find_element(By.CSS_SELECTOR, '#email').send_keys(
                  '${email}'
              )
              driver.find_element(By.CSS_SELECTOR, '#password').send_keys(
                  '${password}'
              )
              driver.find_element(By.XPATH, "//button[contains(., 'Login')]").click()

              wait.until(EC.title_contains("Admin dashboard"))
          finally:
              driver.close()
              driver.quit()
        '';
      in
      [ pkgs.firefox-unwrapped pkgs.geckodriver testRunner ];
  };
  testScript = ''
    start_all()
    castopod.wait_for_unit("castopod-setup.service")
    castopod.wait_for_file("/run/phpfpm/castopod.sock")
    castopod.wait_for_unit("nginx.service")
    castopod.wait_for_open_port(80)
    castopod.wait_until_succeeds("curl -sS -f http://castopod.example.com")
    castopod.succeed("curl -s http://localhost/cp-install | grep 'Create your Super Admin account' > /dev/null")

    with subtest("Create superadmin and log in"):
        castopod.succeed("PYTHONUNBUFFERED=1 systemd-cat -t test-runner test-runner")
  '';
})
