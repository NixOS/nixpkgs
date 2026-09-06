{ ... }:

{
  name = "orbit";

  nodes.machine =
    { pkgs, ... }:
    {
      environment.etc."fleet/enroll-secret".text = "test-secret";

      services.orbit = {
        enable = true;
        orbitPackage = pkgs.writeShellApplication {
          name = "orbit";
          text = ''
            test "$ORBIT_FLEET_URL" = "https://fleet.example.test"
            test -r "$ORBIT_ENROLL_SECRET_PATH"
            test "$(cat "$ORBIT_ENROLL_SECRET_PATH")" = "test-secret"
            test -x "$ORBIT_OSQUERYD_PATH"
            test -x "$ORBIT_DESKTOP_PATH"
            test -x "$ORBIT_BROWSER_PATH"
            test "$ORBIT_OSQUERY_LOG_PATH" = "/var/log/orbit/osquery"
            test "$ORBIT_DISABLE_SETUP_EXPERIENCE" = "true"
            command -v bash
            command -v zsh
            command -v python3
            test "$(command -v sudo)" = "/run/wrappers/bin/sudo"
            sleep infinity
          '';
        };
        osqueryPackage = pkgs.writeShellApplication {
          name = "osqueryd";
          text = "echo osquery";
        };
        desktop = {
          enable = true;
          package = pkgs.writeShellApplication {
            name = "fleet-desktop";
            text = "echo fleet-desktop";
          };
          alternativeBrowserHost = "fleet-browser.example.test";
        };
        setupExperience = {
          enable = false;
          browserPackage = pkgs.writeShellApplication {
            name = "xdg-open";
            text = "echo browser";
          };
        };
        fleetUrl = "https://fleet.example.test";
        enrollSecretPath = "/etc/fleet/enroll-secret";
        debug = true;
        enableScripts = true;
        scriptPackages = [
          pkgs.bash
          pkgs.zsh
          pkgs.python3
        ];
        hostIdentifier = "uuid";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("orbit.service")
    machine.succeed("systemctl is-active orbit.service")
    machine.succeed("test -d /var/lib/orbit")
    machine.succeed("test -d /var/log/orbit")
  '';
}
