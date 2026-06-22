{ lib, pkgs, ... }:
let
  expectedPath = "/tmp/syncthing-default";
in
{
  name = "syncthing-defaults";
  meta.maintainers = with pkgs.lib.maintainers; [ seudonym ];

  nodes.machine =
    { pkgs, ... }:
    {
      environment.systemPackages = [
        pkgs.libxml2
        pkgs.curl
      ];
      services.syncthing = {
        enable = true;
        settings.defaults.folder.path = expectedPath;
      };
    };

  testScript = ''
    import json

    machine.wait_for_unit("syncthing.service")
    machine.wait_for_unit("syncthing-init.service")

    # Get the API key by parsing the config.xml
    api_key = machine.succeed(
        "xmllint --xpath 'string(configuration/gui/apikey)' /var/lib/syncthing/.config/syncthing/config.xml"
    ).strip()

    # Query the defaults/folder endpoint via Syncthing's REST API
    config = json.loads(machine.succeed(
        f"curl -Ssf -H 'X-API-Key: {api_key}' http://127.0.0.1:8384/rest/config/defaults/folder"
    ))

    actual_path = config.get('path')
    assert actual_path == "${expectedPath}", f"Default folder path is '{actual_path}', but expected '${expectedPath}'"
    machine.log(f"Success: Default folder path is correctly set to '{actual_path}'")
  '';
}
