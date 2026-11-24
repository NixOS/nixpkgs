{ lib, pkgs, ... }:
{
  name = "aurral";
  meta = with lib.maintainers; {
    maintainers = [ hougo ];
  };

  nodes = {
    machine =
      { pkgs, ... }:
      {
        services.aurral = {
          enable = true;
          plugins = [ pkgs.aurralPlugins.lidarr ];
          environment = {
            LIBRARY_FOLDER = "/var/lib/aurral-music";
          };
        };
      };
  };

  testScript = ''
    import json
    import shlex

    start_all()

    machine.wait_for_unit("aurral.service")
    machine.wait_for_open_port(3001)

    machine.succeed('curl --fail http://localhost:3001/api/health')

    with subtest("Packaged and user-installed plugins coexist"):
        api = "http://localhost:3001/api"
        credentials = json.dumps({"authUser": "admin", "authPassword": "test-password"})
        account = machine.succeed(f"curl -fsS --json {shlex.quote(credentials)} {api}/onboarding/complete")
        auth = f"Authorization: Bearer {json.loads(account)['token']}"
        machine.succeed(
            "runuser -u aurral -- cp -r --no-preserve=mode "
            "${pkgs.aurralPlugins.setlists} /var/lib/aurral/plugins/setlists"
        )
        plugins = machine.succeed(f"curl -fsS -H '{auth}' {api}/plugins")
        installed = {p["id"]: p for p in json.loads(plugins)["plugins"]}
        assert installed["setlists"]["manifest"]["name"] == "Setlists"
        lidarr = installed["lidarr"]
        assert lidarr["manifest"]["name"] == "Lidarr"
        assert not lidarr["enabled"]
        machine.succeed(f"curl -fsS -X DELETE -H '{auth}' {api}/plugins/setlists")
        machine.fail(f"curl -fsS -X DELETE -H '{auth}' {api}/plugins/lidarr")
  '';
}
