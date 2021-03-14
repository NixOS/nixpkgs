import ./make-test-python.nix (
  { pkgs, ... }:

    let
      password = "some_password";
      repository = "/tmp/restic-backup";
      rcloneRepository = "rclone:local:/tmp/restic-rclone-backup";

      passwordFile = "${pkgs.writeText "password" "correcthorsebatterystaple"}";
      initialize = true;
      paths = [ "/opt" ];
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
                    inherit repository passwordFile initialize paths pruneOpts;
                  };
                  rclonebackup = {
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
                    inherit passwordFile initialize paths pruneOpts;
                  };
                };

                environment.sessionVariables.RCLONE_CONFIG_LOCAL_TYPE = "local";
              };
        };

        testScript = ''
          server.start()
          server.wait_for_unit("dbus.socket")
          server.fail(
              "${pkgs.restic}/bin/restic -r ${repository} -p ${passwordFile} snapshots",
              "${pkgs.restic}/bin/restic -r ${rcloneRepository} -p ${passwordFile} snapshots",
          )
          server.succeed(
              "mkdir -p /opt",
              "touch /opt/some_file",
              "mkdir -p /tmp/restic-rclone-backup",
              "timedatectl set-time '2016-12-13 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "systemctl start restic-backups-rclonebackup.service",
              '${pkgs.restic}/bin/restic -r ${repository} -p ${passwordFile} snapshots -c | grep -e "^1 snapshot"',
              '${pkgs.restic}/bin/restic -r ${rcloneRepository} -p ${passwordFile} snapshots -c | grep -e "^1 snapshot"',
              "timedatectl set-time '2017-12-13 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "systemctl start restic-backups-rclonebackup.service",
              "timedatectl set-time '2018-12-13 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "systemctl start restic-backups-rclonebackup.service",
              "timedatectl set-time '2018-12-14 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "systemctl start restic-backups-rclonebackup.service",
              "timedatectl set-time '2018-12-15 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "systemctl start restic-backups-rclonebackup.service",
              "timedatectl set-time '2018-12-16 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "systemctl start restic-backups-rclonebackup.service",
              '${pkgs.restic}/bin/restic -r ${repository} -p ${passwordFile} snapshots -c | grep -e "^4 snapshot"',
              '${pkgs.restic}/bin/restic -r ${rcloneRepository} -p ${passwordFile} snapshots -c | grep -e "^4 snapshot"',
          )
        '';
      }
)
