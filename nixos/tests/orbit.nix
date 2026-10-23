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
            test -x "$NIX_ORBIT_OSQUERYD_PATH"
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
        fleetUrl = "https://fleet.example.test";
        enrollSecretPath = "/etc/fleet/enroll-secret";
        debug = true;
        enableScripts = true;
        hostIdentifier = "uuid";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("orbit.service")
  '';
}
