{ name, serverConfig }:

import ../../make-test-python.nix {
  inherit name;

  nodes = {
    server = { lib, pkgs, ... } @ args: with lib; {
      options.test-support.etag.root = mkOption {
        default = ./test-1;
      };

      config = serverConfig args // {
        specialisation.test-2.configuration = {
          test-support.etag.root = ./test-2;
        };

        networking.firewall.allowedTCPPorts = [ 80 ];
      };
    };

    client = { pkgs, lib, ... }: {
      virtualisation.memorySize = 512;

      environment.systemPackages = let
        testRunner = pkgs.writers.writePython3Bin "test-runner" {
          libraries = [ pkgs.python3Packages.selenium ];
        } ''
          import os
          import time

          from selenium.webdriver import Firefox
          from selenium.webdriver.firefox.options import Options

          options = Options()
          options.add_argument('--headless')
          driver = Firefox(options=options)

          driver.implicitly_wait(20)
          driver.get('http://server')
          driver.find_element_by_xpath('//div[@foo="1"]')
          open('/tmp/test-1-complete', 'w').close()

          while not os.path.exists('/tmp/test-2-ready'):
              time.sleep(0.5)

          driver.get('http://server')
          driver.find_element_by_xpath('//div[@foo="2"]')
          open('/tmp/test-2-complete', 'w').close()
        '';
      in [ pkgs.firefox-unwrapped pkgs.geckodriver testRunner ];
    };
  };

  testScript = { nodes, ... }: let
    inherit (nodes.server.config.system.build) toplevel;
  in ''
    start_all()

    server.wait_for_unit("multi-user.target")
    client.wait_for_unit("multi-user.target")

    client.execute("test-runner &")
    client.wait_for_file("/tmp/test-1-complete")

    server.succeed(
        "${toplevel}/specialisation/test-2/bin/switch-to-configuration test"
    )

    client.succeed("touch /tmp/test-2-ready")
    client.wait_for_file("/tmp/test-2-complete")
  '';
}
