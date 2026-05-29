{ lib, ... }:

{
  name = "qui";
  meta.maintainers = with lib.maintainers; [ undefined-landmark ];

  nodes.machine =
    { pkgs, ... }:
    let
      # We create this secret in the Nix store (making it readable by everyone).
      # DO NOT DO THIS OUTSIDE OF TESTS!!
      testSecretFile = pkgs.writeText "session_secret" "not-secret";
    in
    {
      services.qui = {
        enable = true;
        secretFile = testSecretFile;
      };

      specialisation = {
        # Use port other than default to test if settings options work.
        settingsPort.configuration = {
          services.qui = {
            enable = true;
            secretFile = testSecretFile;
            settings.port = 7777;
          };
        };

        # Use dataDir other than default to test if the wiring is correct
        relocatedDataDir.configuration = {
          services.qui = {
            enable = true;
            secretFile = testSecretFile;
            settings.dataDir = "/var/lib/qui-data";
          };

          systemd.tmpfiles.settings."10-qui"."/var/lib/qui-data".d = {
            user = "qui";
            group = "qui";
            mode = "0750";
          };
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      settingsPort = "${nodes.machine.system.build.toplevel}/specialisation/settingsPort";
      relocatedDataDir = "${nodes.machine.system.build.toplevel}/specialisation/relocatedDataDir";
    in
    # python
    ''
      def test_webui(port):
        machine.wait_for_unit("qui.service")
        machine.wait_for_open_port(port)
        machine.wait_until_succeeds(f"curl --fail http://localhost:{port}")

      test_webui(7476)
      machine.succeed("test -f /var/lib/qui/qui.db")
      machine.succeed('systemctl show qui.service --property=StateDirectory --value | grep -qx qui')

      machine.succeed("${settingsPort}/bin/switch-to-configuration test")
      test_webui(7777)

      machine.succeed("${relocatedDataDir}/bin/switch-to-configuration test")
      test_webui(7476)
      machine.succeed("test -f /var/lib/qui-data/qui.db")
      machine.succeed('test -z "$(systemctl show qui.service --property=StateDirectory --value)"')
    '';
}
