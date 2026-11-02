{
  pkgs,
  lib,
  package,
  ...
}:
{
  name = "incus-ui";

  meta = {
    maintainers = lib.teams.lxc.members;
  };

  nodes.machine =
    { lib, ... }:
    {

      virtualisation.incus = {
        enable = true;
        inherit package;

        preseed.config."core.https_address" = ":8443";
        ui.enable = true;
      };

      networking.nftables.enable = true;

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

                options = Options()
                options.add_argument("--headless")
                service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501

                driver = webdriver.Firefox(options=options, service=service)
                driver.implicitly_wait(10)
                driver.get("https://localhost:8443/ui")

                wait = WebDriverWait(driver, 60)

                assert len(driver.find_elements(By.CLASS_NAME, "l-application")) > 0
                assert len(driver.find_elements(By.CLASS_NAME, "l-navigation__drawer")) > 0

                driver.close()
              '';
        in
        with pkgs;
        [
          curl
          firefox-unwrapped
          geckodriver
          seleniumScript
        ];
    };

  testScript = ''
    machine.wait_for_unit("incus.service")
    machine.wait_for_unit("incus-preseed.service")

    # Check that the INCUS_UI environment variable is populated in the systemd unit
    machine.succeed("systemctl cat incus.service | grep 'INCUS_UI'")

    # Ensure the endpoint returns an HTML page with 'Incus UI' in the title
    machine.succeed("curl -kLs https://localhost:8443/ui | grep '<title>Incus UI</title>'")

    # Ensure the documentation is rendering correctly
    machine.succeed("curl -kLs https://localhost:8443/documentation/ | grep '<title>Incus documentation</title>'")

    # Ensure the application is actually rendered by the Javascript
    machine.succeed("PYTHONUNBUFFERED=1 selenium-script")
  '';
}
