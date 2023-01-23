import ./make-test-python.nix (
  { pkgs, ... }:

  let
    remoteRepository = "/tmp/restic-backup";
    remoteFromFileRepository = "/tmp/restic-backup-from-file";
    rcloneRepository = "rclone:local:/tmp/restic-rclone-backup";

    backupPrepareCommand = ''
      touch /tmp/backupPrepareCommand
      test ! -e /tmp/backupCleanupCommand
    '';

    backupCleanupCommand = ''
      rm /tmp/backupPrepareCommand
      touch /tmp/backupCleanupCommand
    '';

    testDir = pkgs.stdenvNoCC.mkDerivation {
      name = "test-files-to-backup";
      unpackPhase = "true";
      installPhase = ''
        mkdir $out
        touch $out/some_file
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
    name = "restic";

    meta = with pkgs.lib.maintainers; {
      maintainers = [ bbigras i077 ];
    };

    nodes = {
      server =
        { pkgs, ... }:
        {
          services.restic.backups = {
            remotebackup = {
              inherit passwordFile paths exclude pruneOpts backupPrepareCommand backupCleanupCommand;
              repository = remoteRepository;
              initialize = true;
            };
            remote-from-file-backup = {
              inherit passwordFile paths exclude pruneOpts;
              initialize = true;
              repositoryFile = pkgs.writeText "repositoryFile" remoteFromFileRepository;
            };
            rclonebackup = {
              inherit passwordFile paths exclude pruneOpts;
              initialize = true;
              repository = rcloneRepository;
              rcloneConfig = {
                type = "local";
                one_file_system = true;
              };

              # This gets overridden by rcloneConfig.type
              rcloneConfigFile = pkgs.writeText "rclone.conf" ''
                [local]
                type=ftp
              '';
            };
            remoteprune = {
              inherit passwordFile;
              repository = remoteRepository;
              pruneOpts = [ "--keep-last 1" ];
            };
            custompackage = {
              inherit passwordFile paths;
              repository = "some-fake-repository";
              package = pkgs.writeShellScriptBin "restic" ''
                echo "$@" >> /tmp/fake-restic.log;
              '';

              pruneOpts = [ "--keep-last 1" ];
              checkOpts = [ "--some-check-option" ];
            };
          };

          environment.sessionVariables.RCLONE_CONFIG_LOCAL_TYPE = "local";
        };
    };

    testScript = ''
      server.start()
      server.wait_for_unit("dbus.socket")
      server.fail(
          "${pkgs.restic}/bin/restic -r ${remoteRepository} -p ${passwordFile} snapshots",
          '${pkgs.restic}/bin/restic -r ${remoteFromFileRepository} -p ${passwordFile} snapshots"',
          "${pkgs.restic}/bin/restic -r ${rcloneRepository} -p ${passwordFile} snapshots",
          "grep 'backup .* /opt' /tmp/fake-restic.log",
      )
      server.succeed(
          # set up
          "cp -rT ${testDir} /opt",
          "touch /opt/excluded_file_1 /opt/excluded_file_2",
          "mkdir -p /tmp/restic-rclone-backup",

          # test that remotebackup runs custom commands and produces a snapshot
          "timedatectl set-time '2016-12-13 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /tmp/backupCleanupCommand",
          '${pkgs.restic}/bin/restic -r ${remoteRepository} -p ${passwordFile} snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

          # test that restoring that snapshot produces the same directory
          "mkdir /tmp/restore-1",
          "${pkgs.restic}/bin/restic -r ${remoteRepository} -p ${passwordFile} restore latest -t /tmp/restore-1",
          "diff -ru ${testDir} /tmp/restore-1/opt",

          # test that remote-from-file-backup produces a snapshot
          "systemctl start restic-backups-remote-from-file-backup.service",
          '${pkgs.restic}/bin/restic -r ${remoteFromFileRepository} -p ${passwordFile} snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

          # test that rclonebackup produces a snapshot
          "systemctl start restic-backups-rclonebackup.service",
          '${pkgs.restic}/bin/restic -r ${rcloneRepository} -p ${passwordFile} snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

          # test that custompackage runs both `restic backup` and `restic check` with reasonable commandlines
          "systemctl start restic-backups-custompackage.service",
          "grep 'backup .* /opt' /tmp/fake-restic.log",
          "grep 'check .* --some-check-option' /tmp/fake-restic.log",

          # test that we can create four snapshots in remotebackup and rclonebackup
          "timedatectl set-time '2017-12-13 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /tmp/backupCleanupCommand",
          "systemctl start restic-backups-rclonebackup.service",

          "timedatectl set-time '2018-12-13 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /tmp/backupCleanupCommand",
          "systemctl start restic-backups-rclonebackup.service",

          "timedatectl set-time '2018-12-14 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /tmp/backupCleanupCommand",
          "systemctl start restic-backups-rclonebackup.service",

          "timedatectl set-time '2018-12-15 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /tmp/backupCleanupCommand",
          "systemctl start restic-backups-rclonebackup.service",

          "timedatectl set-time '2018-12-16 13:45'",
          "systemctl start restic-backups-remotebackup.service",
          "rm /tmp/backupCleanupCommand",
          "systemctl start restic-backups-rclonebackup.service",

          '${pkgs.restic}/bin/restic -r ${remoteRepository} -p ${passwordFile} snapshots --json | ${pkgs.jq}/bin/jq "length | . == 4"',
          '${pkgs.restic}/bin/restic -r ${rcloneRepository} -p ${passwordFile} snapshots --json | ${pkgs.jq}/bin/jq "length | . == 4"',

          # test that remoteprune brings us back to 1 snapshot in remotebackup
          "systemctl start restic-backups-remoteprune.service",
          '${pkgs.restic}/bin/restic -r ${remoteRepository} -p ${passwordFile} snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

      )
    '';
  }
)
