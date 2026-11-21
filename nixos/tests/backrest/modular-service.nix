{ lib, hostPkgs, ... }:
{
  _class = "nixosTest";
  name = "backrest-modular";
  nodes.machine =
    { pkgs, ... }:
    {
      system.services.backrest = {
        imports = [ pkgs.backrest.services.default ];
        backrest = {
          address = "0.0.0.0";
          configPath = "/var/lib/backrest/config.json";
        };
      };

      systemd.services.backrest.preStart = ''
        mkdir -p /var/lib/backrest
        cp ${./config.json} /var/lib/backrest/config.json
        chmod 644 /var/lib/backrest/config.json
      '';
      networking.firewall.allowedTCPPorts = [ 9898 ];
    };

  testScript = /* py */ ''
    machine.succeed("mkdir -p /srv/backup-source")
    machine.succeed("echo 'important backup data' > /srv/backup-source/data.txt")

    machine.succeed("echo 'root owned data' > /srv/backup-source/root.txt")
    machine.succeed("chown root:root /srv/backup-source/root.txt")
    machine.succeed("chmod 600 /srv/backup-source/root.txt")

    machine.succeed("echo 'testpass' > /srv/restic-password")

    machine.start_job("backrest.service")
    machine.wait_for_unit("backrest.service")
    machine.wait_for_open_port(9898)

    machine.succeed("curl -fsS http://localhost:9898")

    # Trigger a backup manually via the API and wait for it to complete
    machine.succeed("""curl -fsS -X POST -H 'Content-Type: application/json' -d '{"value": "test-backup"}' http://localhost:9898/v1.Backrest/Backup""")

    restic_cmd = "${hostPkgs.restic}/bin/restic -r /var/lib/backrest/restic-repo --password-file /srv/restic-password"
    machine.succeed(f"{restic_cmd} ls latest | grep -q data.txt")
    machine.succeed(f"{restic_cmd} ls latest | grep -q root.txt")
  '';

  meta.maintainers = with lib.maintainers; [ phanirithvij ];
}
