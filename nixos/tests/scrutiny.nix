import ./make-test-python.nix ({ lib, ... }:

{
  name = "scrutiny";
  meta.maintainers = with lib.maintainers; [ jnsgruk ];

  nodes = {
    machine = { self, pkgs, lib, ... }: {
      services = {
        scrutiny.enable = true;
        scrutiny.collector.enable = true;
      };

      environment.systemPackages =
        let
          seleniumScript = pkgs.writers.writePython3Bin "selenium-script"
            {
              libraries = with pkgs.python3Packages; [ selenium ];
            } ''
            from selenium import webdriver
            from selenium.webdriver.common.by import By
            from selenium.webdriver.firefox.options import Options
            from selenium.webdriver.support.ui import WebDriverWait
            from selenium.webdriver.support import expected_conditions as EC

            options = Options()
            options.add_argument("--headless")
            service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501

            driver = webdriver.Firefox(options=options, service=service)
            driver.implicitly_wait(10)
            driver.get("http://localhost:8080/web/dashboard")

            wait = WebDriverWait(driver, 10).until(
              EC.text_to_be_present_in_element(
                (By.TAG_NAME, "body"), "Drive health at a glance")
            )

            body_text = driver.find_element(By.TAG_NAME, "body").text
            assert "Temperature history for each device" in body_text

            driver.close()
          '';
        in
        with pkgs; [ curl firefox-unwrapped geckodriver seleniumScript ];
    };
  };
  # This is the test code that will check if our service is running correctly:
  testScript = ''
    start_all()

    # Wait for Scrutiny to be available
    machine.wait_for_unit("scrutiny")
    machine.wait_for_open_port(8080)

    # Ensure the API responds as we expect
    output = machine.succeed("curl localhost:8080/api/health")
    assert output == '{"success":true}'

    # Start the collector service to send some metrics
    collect = machine.succeed("systemctl start scrutiny-collector.service")

    # Ensure the application is actually rendered by the Javascript
    machine.succeed("PYTHONUNBUFFERED=1 selenium-script")
  '';
})
