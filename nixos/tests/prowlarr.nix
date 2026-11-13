{ lib, ... }: {
  name = "prowlarr";
  meta.maintainers = with lib.maintainers; [ connor-grady ];

  nodes.machine = {
    services.prowlarr = {
      enable = true;
      settings.auth.apikey = "prowlarrnixostest";
    };
    specialisation.customDataDir.configuration.services.prowlarr.dataDir = "/srv/prowlarr";
  };

  testScript = { nodes, ... }: ''
    import json

    def wait_for_prowlarr():
      machine.wait_for_unit("prowlarr.service")
      machine.wait_for_open_port(9696)
      machine.succeed("curl --fail http://localhost:9696/ping")

    def prowlarr_api(path, curl_args=""):
      return machine.succeed(f"curl --fail --header 'X-Api-Key: ${nodes.machine.services.prowlarr.settings.auth.apikey}' {curl_args} http://localhost:9696/api/v1/{path}")

    with subtest("Prowlarr starts with the default data directory"):
      wait_for_prowlarr()
      prowlarr_api("tag", """--json '{"label": "migrated"}'""")

    with subtest("Prowlarr's state moves to a custom data directory"):
      machine.succeed("systemctl stop prowlarr.service")
      machine.succeed("mv /var/lib/private/prowlarr /srv/prowlarr")
      machine.succeed("${nodes.machine.system.build.toplevel}/specialisation/customDataDir/bin/switch-to-configuration test")
      machine.succeed("systemctl start prowlarr.service")
      wait_for_prowlarr()
      machine.succeed("findmnt --noheadings --output SOURCE --mountpoint /var/lib/private/prowlarr | grep -F '[/srv/prowlarr]'")
      tags = json.loads(prowlarr_api("tag"))
      assert [tag["label"] for tag in tags] == ["migrated"], "Prowlarr's state did not carry over"

    with subtest("systemd-tmpfiles leaves the custom data directory's ownership alone"):
      owner = machine.succeed("stat -c %u:%g /srv/prowlarr")
      machine.succeed("systemd-tmpfiles --create")
      assert machine.succeed("stat -c %u:%g /srv/prowlarr") == owner, "systemd-tmpfiles changed ownership"

    with subtest("Prowlarr requires its bind mount"):
      machine.succeed("systemctl stop var-lib-private-prowlarr.mount")
      machine.fail("systemctl is-active prowlarr.service")
  '';
}
