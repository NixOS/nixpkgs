import ./make-test.nix {
  name = "nginx-etag";

  nodes = {
    server = { pkgs, lib, ... }: {
      networking.firewall.enable = false;
      services.nginx.enable = true;
      services.nginx.virtualHosts.server = {
        root = pkgs.runCommand "testdir" {} ''
          mkdir "$out"
          cat > "$out/test.js" <<EOF
          document.getElementById('foobar').setAttribute('foo', 'bar');
          EOF
          cat > "$out/index.html" <<EOF
          <!DOCTYPE html>
          <div id="foobar">test</div>
          <script src="test.js"></script>
          EOF
        '';
      };

      nesting.clone = lib.singleton {
        services.nginx.virtualHosts.server = {
          root = lib.mkForce (pkgs.runCommand "testdir2" {} ''
            mkdir "$out"
            cat > "$out/test.js" <<EOF
            document.getElementById('foobar').setAttribute('foo', 'yay');
            EOF
            cat > "$out/index.html" <<EOF
            <!DOCTYPE html>
            <div id="foobar">test</div>
            <script src="test.js"></script>
            EOF
          '');
        };
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
          driver.get('http://server/')
          driver.find_element_by_xpath('//div[@foo="bar"]')
          open('/tmp/passed_stage1', 'w')

          while not os.path.exists('/tmp/proceed'):
              time.sleep(0.5)

          driver.get('http://server/')
          driver.find_element_by_xpath('//div[@foo="yay"]')
          open('/tmp/passed', 'w')
        '';
      in [ pkgs.firefox-unwrapped pkgs.geckodriver testRunner ];
    };
  };

  testScript = { nodes, ... }: let
    inherit (nodes.server.config.system.build) toplevel;
    newSystem = "${toplevel}/fine-tune/child-1";
  in ''
    startAll;

    $server->waitForUnit('nginx.service');
    $client->waitForUnit('multi-user.target');
    $client->execute('test-runner &');
    $client->waitForFile('/tmp/passed_stage1');

    $server->succeed('${newSystem}/bin/switch-to-configuration test >&2');
    $client->succeed('touch /tmp/proceed');

    $client->waitForFile('/tmp/passed');
  '';
}
