import ./make-test-python.nix (
  { pkgs, ... }:

  let
    remoteRepository = "rest:http://restic_rest_server:8001/";

    backupPrepareCommand = ''
      touch /root/backupPrepareCommand
      test ! -e /root/backupCleanupCommand
    '';

    backupCleanupCommand = ''
      rm /root/backupPrepareCommand
      touch /root/backupCleanupCommand
    '';

    testDir = pkgs.stdenvNoCC.mkDerivation {
      name = "test-files-to-backup";
      unpackPhase = "true";
      installPhase = ''
        mkdir $out
        echo some_file > $out/some_file
        echo some_other_file > $out/some_other_file
        mkdir $out/a_dir
        echo a_file > $out/a_dir/a_file
      '';
    };

    passwordFile = "${pkgs.writeText "password" "correcthorsebatterystaple"}";
    paths = [ "/opt" ];
    exclude = [ "/opt/excluded_file_*" ];
    pruneOpts = [
      "--keep-daily 2"
      "--keep-weekly 1"
      "--keep-monthly 1"
      "--keep-yearly 99"
    ];
  in
  {
    name = "restic-rest-server";

    nodes = {
      restic_rest_server = {
        services.restic.server = {
          enable = true;
          extraFlags = [ "--no-auth" ];
          listenAddress = "8001";
        };
        networking.firewall.allowedTCPPorts = [ 8001 ];
      };
      server = {
        services.restic.backups = {
          remotebackup = {
            inherit
              passwordFile
              paths
              exclude
              pruneOpts
              backupPrepareCommand
              backupCleanupCommand
              ;
            repository = remoteRepository;
            initialize = true;
            timerConfig = null; # has no effect here, just checking that it doesn't break the service
          };
          remoteprune = {
            inherit passwordFile;
            repository = remoteRepository;
            pruneOpts = [ "--keep-last 1" ];
          };
        };
      };
    };

    testScript = ''
      restic_rest_server.start()
      server.start()
      restic_rest_server.wait_for_unit("restic-rest-server.socket")
      restic_rest_server.wait_for_open_port(8001)
      server.wait_for_unit("dbus.socket")
      server.fail(
          "restic-remotebackup snapshots",
      )
      server.succeed(
          # set up
          "cp -rT ${testDir} /opt",
          "touch /opt/excluded_file_1 /opt/excluded_file_2",

          # test that remotebackup runs custom commands and produces a snapshot
          "timedatectl set-time '2016-12-13 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /root/backupCleanupCommand",
          'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

          # test that restoring that snapshot produces the same directory
          "mkdir /tmp/restore-1",
          "restic-remotebackup restore latest -t /tmp/restore-1",
          "diff -ru ${testDir} /tmp/restore-1/opt",

          # test that we can create four snapshots in remotebackup and rclonebackup
          "timedatectl set-time '2017-12-13 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /root/backupCleanupCommand",

          "timedatectl set-time '2018-12-13 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /root/backupCleanupCommand",

          "timedatectl set-time '2018-12-14 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /root/backupCleanupCommand",

          "timedatectl set-time '2018-12-15 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /root/backupCleanupCommand",

          "timedatectl set-time '2018-12-16 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /root/backupCleanupCommand",

          'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 4"',

          # test that remoteprune brings us back to 1 snapshot in remotebackup
          "systemctl start restic-backups-remoteprune.service",
          'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',
      )
    '';
  }
)
