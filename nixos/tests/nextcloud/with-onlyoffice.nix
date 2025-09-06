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
    meta = {
      maintainers = lib.teams.nextcloud.members;
    };

    imports = [ testBase ];

    nodes = {
      nextcloud =
        { config, pkgs, ... }:
        {
          nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
            "corefonts"
          ];

          environment.systemPackages = [
            pkgs.firefox-unwrapped
          ];

          systemd.tmpfiles.rules = [
            "d /var/lib/nextcloud-data 0750 nextcloud nginx - -"
          ];

          services.nextcloud = {
            enable = true;
            config.dbtype = "sqlite";
            datadir = "/var/lib/nextcloud-data";
            #autoUpdateApps = {
            #  enable = true;
            #  startAt = "20:00";
            #};
            phpExtraExtensions = all: [ all.bz2 ];
            extraApps = with config.services.nextcloud.package.packages.apps; {
              inherit onlyoffice;
            };
          };
          services.onlyoffice = {
            enable = true;
            port = 8001;
            hostname = "onlyoffice.localhost";
            jwtSecretFile = "${./onlyoffice-jwt-secret.txt}";
          };
        };
    };

    test-helpers.extraTests =
      { nodes, ... }:
      let
        seleniumScript = pkgs.writers.writePython3Bin "selenium-script"
          {
            libraries = with pkgs.python3Packages; [ selenium ];
          }
          ''
            # from sys import stderr
            # from time import time
            from selenium import webdriver
            from selenium.webdriver.common.by import By
            from selenium.webdriver.firefox.options import Options
            # from selenium.webdriver.support.ui import WebDriverWait
            # from selenium.webdriver.support import expected_conditions as EC
      
            options = Options()
            options.add_argument("--headless")
            service = webdriver.FirefoxService(executable_path="${lib.getExe pkgs.geckodriver}")  # noqa: E501
      
            driver = webdriver.Firefox(options=options, service=service)
            driver.implicitly_wait(10)
            driver.get("https://nextcloud")
            driver.find_element(By.PARTIAL_LINK_TEXT, "Login").click()
      
            driver.close()
          '';
      in
      ''
        print('XXXX')
        # import subprocess
        # subprocess.run(["cat", "/nix/store/jqaxxkl2xnp74sb1r3vj8z921r7c7fhl-onlyoffice-documentserver-8.3.2/etc/onlyoffice/documentserver/default.json"])

        nextcloud.wait_for_unit("onlyoffice-converter.service")
        nextcloud.wait_for_unit("onlyoffice-docservice.service")

        with subtest("File is in proper nextcloud home"):
            nextcloud.succeed("test -f ${nodes.nextcloud.services.nextcloud.datadir}/data/root/files/test-shared-file")

        nextcloud.succeed("${lib.getExe seleniumScript}")
      '';
  }
)
