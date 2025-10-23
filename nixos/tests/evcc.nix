{ pkgs, lib, ... }:

let
  port = "1234";
in
{
  name = "evcc";
  meta.maintainers = with lib.maintainers; [ hexa ];

  nodes = {
    machine = {
      services.evcc = {
        enable = true;
        # This is NOT a safe way to deal with secrets in production
        environmentFile = pkgs.writeText "evcc-secrets" ''
          PORT=${toString port}
        '';
        settings = {
          network = {
            schema = "http";
            host = "localhost";
            port = "$PORT";
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
                cmd = "/bin/sh -c 'echo A'";
              };
              enabled = {
                source = "script";
                cmd = "/bin/sh -c 'echo false'";
              };
              enable = {
                source = "script";
                cmd = "/bin/sh -c 'echo true'";
              };
              maxcurrent = {
                source = "script";
                cmd = "/bin/sh -c 'echo 7200'";
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
    machine.wait_for_open_port(${port})

    with subtest("Check package version propagates into frontend"):
        machine.fail(
            "curl --fail http://localhost:${port} | grep '0.0.1-alpha'"
        )
        machine.succeed(
            "curl --fail http://localhost:${port} | grep '${pkgs.evcc.version}'"
        )

    with subtest("Check journal for errors"):
        _, output = machine.execute("journalctl -o cat -u evcc.service")
        assert "FATAL" not in output

    with subtest("Check systemd hardening"):
        _, output = machine.execute("systemd-analyze security evcc.service | grep -v '✓'")
        machine.log(output)
  '';
}
