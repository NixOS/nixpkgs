import ./make-test-python.nix (
  { pkgs, lib, ... }:

  {
    name = "evcc";
    meta.maintainers = with lib.maintainers; [ hexa ];

    nodes = {
      machine =
        { config, ... }:
        {
          services.evcc = {
            enable = true;
            settings = {
              network = {
                schema = "http";
                host = "localhost";
                port = 7070;
              };

              log = "info";

              site = {
                title = "NixOS Test";
                meters = {
                  grid = "grid";
                  pv = "pv";
                };
              };

              meters = [
                {
                  type = "custom";
                  name = "grid";
                  power = {
                    source = "script";
                    cmd = "/bin/sh -c 'echo -4500'";
                  };
                }
                {
                  type = "custom";
                  name = "pv";
                  power = {
                    source = "script";
                    cmd = "/bin/sh -c 'echo 7500'";
                  };
                }
              ];

              chargers = [
                {
                  name = "dummy-charger";
                  type = "custom";
                  status = {
                    source = "script";
                    cmd = "/bin/sh -c 'echo charger status A'";
                  };
                  enabled = {
                    source = "script";
                    cmd = "/bin/sh -c 'echo charger enabled state false'";
                  };
                  enable = {
                    source = "script";
                    cmd = "/bin/sh -c 'echo set charger enabled state true'";
                  };
                  maxcurrent = {
                    source = "script";
                    cmd = "/bin/sh -c 'echo set charger max current 7200'";
                  };
                }
              ];

              loadpoints = [
                {
                  title = "Dummy";
                  charger = "dummy-charger";
                }
              ];
            };
          };
        };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("evcc.service")
      machine.wait_for_open_port(7070)

      with subtest("Check package version propagates into frontend"):
          machine.fail(
              "curl --fail http://localhost:7070 | grep '0.0.1-alpha'"
          )
          machine.succeed(
              "curl --fail http://localhost:7070 | grep '${pkgs.evcc.version}'"
          )

      with subtest("Check journal for errors"):
          _, output = machine.execute("journalctl -o cat -u evcc.service")
          assert "FATAL" not in output

      with subtest("Check systemd hardening"):
          _, output = machine.execute("systemd-analyze security evcc.service | grep -v '✓'")
          machine.log(output)
    '';
  }
)
