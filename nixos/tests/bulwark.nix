{ pkgs, ... }:
{
  name = "bulwark";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      Cameo007
    ];
  };

  nodes.machine = {
    services.bulwark = {
      enable = true;
      settings.allowCustomJmapEndpoint = true;
      plugins = with pkgs.bulwark-plugins; [
        {
          package = calendar-agenda;
          forceEnabled = true;
        }
        { package = spam-score; }
      ];
    };
  };

  testScript = ''
    import json

    machine.wait_for_unit("bulwark")
    machine.wait_for_open_port(3000)

    status = machine.succeed("curl -f http://localhost:3000/api/health")
    assert json.loads(status)["status"] == "healthy", "The fetched config does not match"

    environment = machine.succeed("systemctl show bulwark --property=Environment --value")
    config_dir = next(
        value.split("=", 1)[1]
        for value in environment.split()
        if value.startswith("ADMIN_CONFIG_DIR=")
    )
    registry = json.loads(machine.succeed(f"cat {config_dir}/plugins/registry.json"))
    plugins = {plugin["id"]: plugin for plugin in registry["plugins"]}
    assert set(plugins) == {"calendar-agenda", "spam-score"}
    assert plugins["calendar-agenda"]["enabled"] is True
    assert plugins["calendar-agenda"]["forceEnabled"] is True
    assert plugins["spam-score"]["enabled"] is True
    assert plugins["spam-score"]["forceEnabled"] is False

    for plugin_id, plugin in plugins.items():
        expected_hash = machine.succeed(
            f"sha256sum {config_dir}/plugins/{plugin_id}.js"
        ).split()[0]
        assert plugin["bundleHash"] == expected_hash
        assert len(plugin["bundleHash"]) == 64

    machine.wait_until_succeeds("journalctl -u bulwark | grep -q 'scheduler not started'")
    machine.fail("journalctl -u bulwark | grep -q 'init skipped'")
  '';
}
