{ pkgs, lib, ... }:

let
  user = "alice"; # from ./common/user-account.nix
  password = "foobar"; # from ./common/user-account.nix

  # A minimal Cockpit plugin that runs `hello` and displays the output
  # This tests that the cockpitPath mechanism works correctly
  helloPlugin =
    pkgs.runCommand "cockpit-hello-test" { } ''
      mkdir -p $out/share/cockpit/hello-test

      cat > $out/share/cockpit/hello-test/manifest.json << 'EOF'
      {
        "name": "hello-test",
        "menu": {
          "index": {
            "label": "Hello Test",
            "order": 100
          }
        }
      }
      EOF

      cat > $out/share/cockpit/hello-test/index.html << 'EOF'
      <!DOCTYPE html>
      <html>
      <head>
        <title>Hello Test</title>
        <meta charset="utf-8">
        <script src="../base1/cockpit.js"></script>
      </head>
      <body>
        <h1>Hello Test Plugin</h1>
        <div id="output">Loading...</div>
        <script src="test.js"></script>
      </body>
      </html>
      EOF

      cat > $out/share/cockpit/hello-test/test.js << 'EOF'
      (function() {
        var output = document.getElementById("output");

        if (typeof cockpit === "undefined") {
          output.innerText = "FAILED: cockpit.js not loaded";
          return;
        }

        cockpit.spawn(["hello"], { err: "message" })
          .then(function(data) {
            output.innerText = "SUCCESS: " + data;
          })
          .catch(function(error) {
            output.innerText = "FAILED: " + (error ? error.message : "unknown error");
          });
      })();
      EOF
    ''
    // {
      passthru.cockpitPath = [ pkgs.hello ];
    };
in
{
  name = "cockpit";
  meta = {
    maintainers = with lib.maintainers; [ lucasew ];
  };
  nodes = {
    server =
      { config, ... }:
      {
        imports = [ ./common/user-account.nix ];
        security.polkit.enable = true;
        users.users.${user} = {
          extraGroups = [ "wheel" ];
        };
        services.cockpit = {
          enable = true;
          port = 7890;
          openFirewall = true;
          plugins = [ helloPlugin ];
          allowed-origins = [
            "https://server:${toString config.services.cockpit.port}"
          ];
        };
      };
    client =
      { config, ... }:
      {
        imports = [ ./common/user-account.nix ];
        environment.systemPackages =
          let
            seleniumScript =
              pkgs.writers.writePython3Bin "selenium-script"
                {
                  libraries = with pkgs.python3Packages; [ selenium ];
                }
                ''
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
                  driver.get("https://server:7890")


                  def wait_elem(by, query, timeout=10):
                      wait = WebDriverWait(driver, timeout)
                      wait.until(EC.presence_of_element_located((by, query)))


                  def wait_title_contains(title, timeout=10):
                      wait = WebDriverWait(driver, timeout)
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
                  # driver.get("https://server:7890/system")

                  log("Waiting dashboard to load")
                  wait_title_contains("${user}@server")

                  log("Waiting for the frontend to initialize")
                  sleep(1)

                  log("Looking for that banner that tells about limited access")
                  container_iframe = find_element(By.CSS_SELECTOR, 'iframe.container-frame')
                  driver.switch_to.frame(container_iframe)

                  assert "Web console is running in limited access mode" in driver.page_source

                  log("Clicking the sudo button")
                  for button in driver.find_elements(By.TAG_NAME, "button"):
                      if 'admin' in button.text:
                          button.click()
                  driver.switch_to.default_content()

                  log("Checking that /nonexistent is not a thing")
                  assert '/nonexistent' not in driver.page_source
                  assert len(driver.find_elements(By.CSS_SELECTOR, '#machine-reconnect')) == 0

                  log("Checking plugin path")
                  driver.get("https://server:7890/hello-test")
                  sleep(2)
                  for iframe in driver.find_elements(By.TAG_NAME, "iframe"):
                      if "hello-test" in (iframe.get_attribute("src") or ""):
                          driver.switch_to.frame(iframe)
                          break
                  text = driver.find_element(By.ID, "output").text
                  sleep(1)
                  assert "SUCCESS: Hello, world!" in text, f"Plugin failed: {text}"

                  driver.close()
                '';
          in
          with pkgs;
          [
            firefox-unwrapped
            geckodriver
            seleniumScript
          ];
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("sockets.target")
    server.wait_for_open_port(7890)

    client.succeed("curl -k https://server:7890 -o /dev/stderr")
    print(client.succeed("whoami"))
    client.succeed('PYTHONUNBUFFERED=1 selenium-script')
  '';
}
