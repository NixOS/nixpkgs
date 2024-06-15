import ./make-test-python.nix (
  { pkgs, lib, ... }:

  let
    user = "alice"; # from ./common/user-account.nix
    password = "foobar"; # from ./common/user-account.nix
  in {
    name = "cockpit";
    meta = {
      maintainers = with lib.maintainers; [ lucasew ];
    };
    nodes = {
      server = { config, ... }: {
        imports = [ ./common/user-account.nix ];
        security.polkit.enable = true;
        users.users.${user} = {
          extraGroups = [ "wheel" ];
        };
        services.cockpit = {
          enable = true;
          openFirewall = true;
          settings = {
            WebService = {
              Origins = "https://server:9090";
            };
          };
        };
      };
      client = { config, ... }: {
        imports = [ ./common/user-account.nix ];
        environment.systemPackages = let
          seleniumScript = pkgs.writers.writePython3Bin "selenium-script" {
            libraries = with pkgs.python3Packages; [ selenium ];
            } ''
            from selenium import webdriver
            from selenium.webdriver.common.by import By
            from selenium.webdriver.firefox.options import Options
            from selenium.webdriver.support.ui import WebDriverWait
            from selenium.webdriver.support import expected_conditions as EC
            from time import sleep


            def log(msg):
                from sys import stderr
                print(f"[*] {msg}", file=stderr)


            log("Initializing")

            options = Options()
            options.add_argument("--headless")

            service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501
            driver = webdriver.Firefox(options=options, service=service)

            driver.implicitly_wait(10)

            log("Opening homepage")
            driver.get("https://server:9090")

            wait = WebDriverWait(driver, 60)


            def wait_elem(by, query):
                wait.until(EC.presence_of_element_located((by, query)))


            def wait_title_contains(title):
                wait.until(EC.title_contains(title))


            def find_element(by, query):
                return driver.find_element(by, query)


            def set_value(elem, value):
                script = 'arguments[0].value = arguments[1]'
                return driver.execute_script(script, elem, value)


            log("Waiting for the homepage to load")

            # cockpit sets initial title as hostname
            wait_title_contains("server")
            wait_elem(By.CSS_SELECTOR, 'input#login-user-input')

            log("Homepage loaded!")

            log("Filling out username")
            login_input = find_element(By.CSS_SELECTOR, 'input#login-user-input')
            set_value(login_input, "${user}")

            log("Filling out password")
            password_input = find_element(By.CSS_SELECTOR, 'input#login-password-input')
            set_value(password_input, "${password}")

            log("Submitting credentials for login")
            driver.find_element(By.CSS_SELECTOR, 'button#login-button').click()

            # driver.implicitly_wait(1)
            # driver.get("https://server:9090/system")

            log("Waiting dashboard to load")
            wait_title_contains("${user}@server")

            log("Waiting for the frontend to initialize")
            sleep(1)

            log("Looking for that banner that tells about limited access")
            container_iframe = find_element(By.CSS_SELECTOR, 'iframe.container-frame')
            driver.switch_to.frame(container_iframe)

            assert "Web console is running in limited access mode" in driver.page_source

            driver.close()
          '';
        in with pkgs; [ firefox-unwrapped geckodriver seleniumScript ];
      };
    };

    testScript = ''
      start_all()

      server.wait_for_open_port(9090)
      server.wait_for_unit("network.target")
      server.wait_for_unit("multi-user.target")
      server.systemctl("start", "polkit")

      client.wait_for_unit("multi-user.target")

      client.succeed("curl -k https://server:9090 -o /dev/stderr")
      print(client.succeed("whoami"))
      client.succeed('PYTHONUNBUFFERED=1 selenium-script')
    '';
  }
)
