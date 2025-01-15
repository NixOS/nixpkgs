import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "rustic";
    meta.maintainers = with pkgs.lib.maintainers; [
      ekleog
      nobbz
      pmw
    ];

    nodes.machine =
      { pkgs, ... }:
      {
        services.rustic = {
          enable = true;
          profiles."rustic" = {
            repository = {
              repository = "/root/repo";
              password = "foobar"; # obviously don't do that
            };
            forget = {
              keep-last = 1;
            };
          };
          backups.fs.files = {
            sources = [ "/root/backup" ];
            startAt = "minutely";
            pipeJsonInto.prometheus.nodeExporterCollectorFolder = "/root/prometheus-text";
          };
          checks.regularly = {
            startAt = "minutely";
          };
          prune = {
            enable = true;
            startAt = "minutely";
          };
        };

        # Disable the timers, as nixos testing seems ill-adapted to timers
        systemd.timers.rustic-backup-fs.enable = false;
        systemd.timers.rustic-check-regularly.enable = false;
        systemd.timers.rustic-prune.enable = false;
      };

    testScript = ''
      # Initialize the repository
      machine.succeed("mkdir /root/{backup,repo,prometheus-text}")
      machine.succeed("touch /root/backup/first-file")
      machine.succeed("rustic init")

      # Make a first backup
      machine.succeed("systemctl start rustic-backup-fs.service")

      # Check we made one valid backup
      machine.succeed("rustic snapshots") # debug
      machine.succeed("rustic list snapshots | wc -l | egrep '^1$'")
      machine.succeed("rustic check --read-data")

      # Validate the prometheus metrics file was written
      machine.succeed("ls /root/prometheus-text | wc -l | egrep '^1$'")

      # Restore the first backup
      machine.succeed("mkdir /root/restore-1")
      machine.succeed("rustic restore latest /root/restore-1")
      machine.succeed("ls /root/restore-1/root/backup | grep first-file")

      # Add one file and make a new backup
      machine.succeed("touch /root/backup/second-file")
      machine.succeed("systemctl start rustic-backup-fs.service")
      machine.succeed("systemctl start rustic-check-regularly.service")

      # Check we have a second valid backup
      machine.succeed("rustic snapshots") # debug
      machine.succeed("rustic list snapshots | wc -l | egrep '^2$'")
      machine.succeed("rustic check --read-data")

      # Validate we overwrote the prometheus metrics file, without adding a new one
      machine.succeed("ls /root/prometheus-text | wc -l | egrep '^1$'")

      # Restore the second backup
      machine.succeed("mkdir /root/restore-2")
      machine.succeed("rustic restore latest /root/restore-2")
      machine.succeed("ls /root/restore-2/root/backup | grep first-file")
      machine.succeed("ls /root/restore-2/root/backup | grep second-file")

      # Prune the first backup
      machine.succeed("systemctl start rustic-prune.service")
      machine.succeed("systemctl start rustic-check-regularly.service")

      # Check we only have one backup left
      machine.succeed("rustic snapshots") # debug
      machine.succeed("rustic list snapshots | wc -l | egrep '^1$'")
      machine.succeed("rustic check --read-data")

      # Restore the second backup again, checking we didn't, just now, delete it
      machine.succeed("mkdir /root/restore-3")
      machine.succeed("rustic restore latest /root/restore-3")
      machine.succeed("ls /root/restore-3/root/backup | grep first-file")
      machine.succeed("ls /root/restore-3/root/backup | grep second-file")
    '';
  }
)
