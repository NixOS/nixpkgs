{ ... }:
{
  name = "nginx-etag";

  nodes = {
    server =
      { pkgs, lib, ... }:
      {
        networking.firewall.enable = false;
        services.nginx.enable = true;
        services.nginx.virtualHosts.server = {
          root = pkgs.runCommandLocal "testdir" { } ''
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

        specialisation.pass-checks.configuration = {
          services.nginx.virtualHosts.server = {
            root = lib.mkForce (
              pkgs.runCommandLocal "testdir2" { } ''
                mkdir "$out"
                cat > "$out/test.js" <<EOF
                document.getElementById('foobar').setAttribute('foo', 'yay');
                EOF
                cat > "$out/index.html" <<EOF
                <!DOCTYPE html>
                <div id="foobar">test</div>
                <script src="test.js"></script>
                EOF
              ''
            );
          };
        };
      };

    client =
      { pkgs, lib, ... }:
      {
        environment.systemPackages =
          let
            testRunner =
              pkgs.writers.writePython3Bin "test-runner"
                {
                  libraries = [ pkgs.python3Packages.selenium ];
                }
                ''
                  import os
                  import time

                  from selenium.webdriver import Firefox
                  from selenium.webdriver.firefox.options import Options

                  options = Options()
                  options.add_argument('--headless')
                  driver = Firefox(options=options)

                  driver.implicitly_wait(20)
                  driver.get('http://server/')
                  driver.find_element('xpath', '//div[@foo="bar"]')
                  open('/tmp/passed_stage1', 'w')

                  while not os.path.exists('/tmp/proceed'):
                      time.sleep(0.5)

                  driver.get('http://server/')
                  driver.find_element('xpath', '//div[@foo="yay"]')
                  open('/tmp/passed', 'w')
                '';
          in
          [
            pkgs.firefox-unwrapped
            pkgs.geckodriver
            testRunner
          ];
      };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.server.system.build) toplevel;
      newSystem = "${toplevel}/specialisation/pass-checks";
    in
    ''
      start_all()

      server.wait_for_unit("nginx.service")
      client.wait_for_unit("multi-user.target")
      client.execute("test-runner >&2 &")
      client.wait_for_file("/tmp/passed_stage1")

      server.succeed(
          "${newSystem}/bin/switch-to-configuration test >&2"
      )
      client.succeed("touch /tmp/proceed")

      client.wait_for_file("/tmp/passed")
    '';
}
