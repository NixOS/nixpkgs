{ pkgs, ... }:
let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;

  remoteRepository = "/root/restic-backup";
  remoteFromFileRepository = "/root/restic-backup-from-file";
  remoteFromCommandRepository = "/root/restic-backup-from-command";
  remoteInhibitTestRepository = "/root/restic-backup-inhibit-test";
  remoteNoInitRepository = "/root/restic-backup-no-init";
  rcloneRepository = "rclone:local:/root/restic-rclone-backup";
  sftpRepository = "sftp:alice@sftp:backups/test";

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
      echo a_file_2 > $out/a_dir/a_file_2
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
  commandString = "testing";
  command = [
    "echo"
    "-n"
    commandString
  ];
in
{
  name = "restic";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      bbigras
      i077
    ];
  };

  nodes = {
    sftp =
      # Copied from openssh.nix
      { pkgs, ... }:
      {
        services.openssh = {
          enable = true;
          extraConfig = ''
            Match Group sftponly
              ChrootDirectory /srv/sftp
              ForceCommand internal-sftp
          '';
        };

        users.groups = {
          sftponly = { };
        };
        users.users = {
          alice = {
            isNormalUser = true;
            createHome = false;
            group = "sftponly";
            shell = "/run/current-system/sw/bin/nologin";
            openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
          };
        };
      };

    restic =
      { pkgs, ... }:
      {
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
          remote-sftp = {
            inherit
              passwordFile
              paths
              exclude
              pruneOpts
              ;
            repository = sftpRepository;
            initialize = true;
            timerConfig = null; # has no effect here, just checking that it doesn't break the service
            extraOptions = [
              "sftp.command='ssh alice@sftp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -s sftp'"
            ];
          };
          remote-from-file-backup = {
            inherit passwordFile exclude pruneOpts;
            initialize = true;
            repositoryFile = pkgs.writeText "repositoryFile" remoteFromFileRepository;
            paths = [
              "/opt/a_dir/a_file"
              "/opt/a_dir/a_file_2"
            ];
            dynamicFilesFrom = ''
              find /opt -mindepth 1 -maxdepth 1 ! -name a_dir # all files in /opt except for a_dir
            '';
          };
          remote-from-command-backup = {
            inherit
              passwordFile
              pruneOpts
              command
              ;
            initialize = true;
            repository = remoteFromCommandRepository;
          };
          inhibit-test = {
            inherit
              passwordFile
              paths
              exclude
              pruneOpts
              ;
            repository = remoteInhibitTestRepository;
            initialize = true;
            inhibitsSleep = true;
          };
          remote-noinit-backup = {
            inherit
              passwordFile
              exclude
              pruneOpts
              paths
              ;
            initialize = false;
            repository = remoteNoInitRepository;
          };
          rclonebackup = {
            inherit
              passwordFile
              paths
              exclude
              pruneOpts
              ;
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
              echo "$@" >> /root/fake-restic.log;
            '';

            pruneOpts = [ "--keep-last 1" ];
            checkOpts = [ "--some-check-option" ];
          };
        };

        environment.sessionVariables.RCLONE_CONFIG_LOCAL_TYPE = "local";
      };
  };

  testScript = ''
    restic.start()
    sftp.start()
    restic.wait_for_unit("dbus.socket")
    sftp.wait_for_unit("sshd.service")

    restic.systemctl("start network-online.target")
    restic.wait_for_unit("network-online.target")

    sftp.succeed(
      "mkdir -p /srv/sftp/backups",
      "chown alice:sftponly /srv/sftp/backups",
      "chmod 0755 /srv/sftp/backups",
    )

    restic.succeed(
      "mkdir -p /root/.ssh/",
      "cat ${snakeOilEd25519PrivateKey} > /root/.ssh/id_ed25519",
      "chmod 0600 /root/.ssh/id_ed25519",
    )

    restic.fail(
        "restic-remotebackup snapshots",
        "restic-remote-sftp snapshots",
        'restic-remote-from-file-backup snapshots"',
        "restic-rclonebackup snapshots",
        "grep 'backup.* /opt' /root/fake-restic.log",
    )
    restic.succeed(
        # set up
        "cp -rT ${testDir} /opt",
        "touch /opt/excluded_file_1 /opt/excluded_file_2",
        "mkdir -p /root/restic-rclone-backup",
    )

    restic.fail(
        # test that noinit backup in fact does not initialize the repository
        # and thus fails without a pre-initialized repository
        "systemctl start restic-backups-remote-noinit-backup.service",
    )

    restic.succeed(
        # test that remotebackup runs custom commands and produces a snapshot
        "date -s '2016-12-13 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',
    )

    restic.succeed(
        # test that remotebackup runs custom commands and produces a snapshot
        "date -s '2016-12-13 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

        # test that restoring that snapshot produces the same directory
        "mkdir /tmp/restore-1",
        "restic-remotebackup restore latest -t /tmp/restore-1",
        "diff -ru ${testDir} /tmp/restore-1/opt",

        # test that remote-from-file-backup produces a snapshot
        "systemctl start restic-backups-remote-from-file-backup.service",
        'restic-remote-from-file-backup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',
        "mkdir /tmp/restore-2",
        "restic-remote-from-file-backup restore latest -t /tmp/restore-2",
        "diff -ru ${testDir} /tmp/restore-2/opt",

        # test that remote-noinit-backup produces a snapshot once initialized
        "restic-remote-noinit-backup init",
        "systemctl start restic-backups-remote-noinit-backup.service",
        'restic-remote-noinit-backup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

        # test that restoring that snapshot produces the same directory
        "mkdir /tmp/restore-3",
        "${pkgs.restic}/bin/restic -r ${remoteRepository} -p ${passwordFile} restore latest -t /tmp/restore-3",
        "diff -ru ${testDir} /tmp/restore-3/opt",

        # test that remote-from-command-backup produces a snapshot, with the expected contents
        "systemctl start restic-backups-remote-from-command-backup.service",
        'restic-remote-from-command-backup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',
        '[[ $(restic-remote-from-command-backup dump --path /stdin latest stdin) == ${commandString} ]]',

        # test that rclonebackup produces a snapshot
        "systemctl start restic-backups-rclonebackup.service",
        'restic-rclonebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

        # test that custompackage runs both `restic backup` and `restic check` with reasonable commandlines
        "systemctl start restic-backups-custompackage.service",
        "grep 'backup' /root/fake-restic.log",
        "grep 'check.* --some-check-option' /root/fake-restic.log",

        # test that we can create four snapshots in remotebackup and rclonebackup
        "date -s '2017-12-13 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        "systemctl start restic-backups-rclonebackup.service",

        "date -s '2018-12-13 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        "systemctl start restic-backups-rclonebackup.service",

        "date -s '2018-12-14 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        "systemctl start restic-backups-rclonebackup.service",

        "date -s '2018-12-15 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        "systemctl start restic-backups-rclonebackup.service",

        "date -s '2018-12-16 13:45'",
        "systemctl start restic-backups-remotebackup.service",
        "rm /root/backupCleanupCommand",
        "systemctl start restic-backups-rclonebackup.service",

        'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 4"',
        'restic-rclonebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 4"',

        # test that SFTP backup works by copying from the remotebackup
        'restic-remote-sftp init --from-repo ${remoteRepository} --from-password-file ${passwordFile} --copy-chunker-params',
        'restic-remote-sftp copy --from-repo ${remoteRepository} --from-password-file ${passwordFile}',
        'restic-remote-sftp snapshots --json | ${pkgs.jq}/bin/jq "length | . == 4"',

        # test that remoteprune brings us back to 1 snapshot in remotebackup
        "systemctl start restic-backups-remoteprune.service",
        'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',

        # test that remoteprune brings us back to 1 snapshot in remotebackup
        "systemctl start restic-backups-remoteprune.service",
        'restic-remotebackup snapshots --json | ${pkgs.jq}/bin/jq "length | . == 1"',
    )

    # test that the inhibit option is working
    restic.systemctl("start --no-block restic-backups-inhibit-test.service")
    restic.wait_until_succeeds(
        "systemd-inhibit --no-legend --no-pager | grep -q restic",
        5
    )
    # test that the inhibit option is working
    restic.systemctl("start --no-block restic-backups-inhibit-test.service")
    restic.wait_until_succeeds(
        "systemd-inhibit --no-legend --no-pager | grep -q restic",
        5
    )
  '';
}
