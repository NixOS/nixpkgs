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

      # Use port other than default to test if settings options work.
      specialisation.settingsPort.configuration = {
        services.qui = {
          enable = true;
          secretFile = testSecretFile;
          settings.port = 7777;
        };
      };
    };

  testScript =
    { nodes, ... }:
    let
      settingsPort = "${nodes.machine.system.build.toplevel}/specialisation/settingsPort";
    in
    # python
    ''
      def test_webui(port):
        machine.wait_for_unit("qui.service")
        machine.wait_for_open_port(port)
        machine.wait_until_succeeds(f"curl --fail http://localhost:{port}")

      test_webui(7476)

      machine.succeed("${settingsPort}/bin/switch-to-configuration test")
      test_webui(7777)
    '';
}
