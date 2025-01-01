import ../make-test-python.nix ({ pkgs, ... }: {
  name = "lxd-ui";

  nodes.machine = { lib, ... }: {
    virtualisation = {
      lxd.enable = true;
      lxd.ui.enable = true;
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
      with pkgs; [ curl firefox-unwrapped geckodriver seleniumScript ];
  };


  testScript = ''
    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("lxd.service")
    machine.wait_for_file("/var/lib/lxd/unix.socket")

    # Wait for lxd to settle
    machine.succeed("lxd waitready")

    # Configure LXC listen address
    machine.succeed("lxc config set core.https_address :8443")
    machine.succeed("systemctl restart lxd")

    # Check that the LXD_UI environment variable is populated in the systemd unit
    machine.succeed("cat /etc/systemd/system/lxd.service | grep 'LXD_UI'")

    # Ensure the endpoint returns an HTML page with 'LXD UI' in the title
    machine.succeed("curl -kLs https://localhost:8443/ui | grep '<title>LXD UI</title>'")

    # Ensure the application is actually rendered by the Javascript
    machine.succeed("PYTHONUNBUFFERED=1 selenium-script")
  '';
})
