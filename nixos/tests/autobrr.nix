{ lib, ... }:

{
  name = "autobrr";
  meta.maintainers = with lib.maintainers; [ av-gal ];

  nodes.machine = {
    services.autobrr.enable = true;

    # Use port other than default to test if settings options work.
    specialisation.settingsPort.configuration = {
      services.autobrr = {
        enable = true;
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
        machine.wait_for_unit("autobrr.service")
        machine.wait_for_open_port(port)
        machine.wait_until_succeeds(f"curl --fail http://localhost:{port}")

      test_webui(7474)

      machine.succeed("${settingsPort}/bin/switch-to-configuration test")
      test_webui(7777)
    '';
}
