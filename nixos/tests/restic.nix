import ./make-test-python.nix (
  { pkgs, ... }:

    let
      password = "some_password";
      repository = "/tmp/restic-backup";
      passwordFile = pkgs.writeText "password" "correcthorsebatterystaple";
    in
      {
        name = "restic";

        meta = with pkgs.stdenv.lib.maintainers; {
          maintainers = [ bbigras ];
        };

        nodes = {
          server =
            { ... }:
              {
                services.restic.backups = {
                  remotebackup = {
                    inherit repository;
                    passwordFile = "${passwordFile}";
                    initialize = true;
                    paths = [ "/opt" ];
                    pruneOpts = [
                      "--keep-daily 2"
                      "--keep-weekly 1"
                      "--keep-monthly 1"
                      "--keep-yearly 99"
                    ];
                  };
                };
              };
        };

        testScript = ''
          server.start()
          server.wait_for_unit("dbus.socket")
          server.fail(
              "${pkgs.restic}/bin/restic -r ${repository} -p ${passwordFile} snapshots"
          )
          server.succeed(
              "mkdir -p /opt",
              "touch /opt/some_file",
              "timedatectl set-time '2016-12-13 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              '${pkgs.restic}/bin/restic -r ${repository} -p ${passwordFile} snapshots -c | grep -e "^1 snapshot"',
              "timedatectl set-time '2017-12-13 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "timedatectl set-time '2018-12-13 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "timedatectl set-time '2018-12-14 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "timedatectl set-time '2018-12-15 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              "timedatectl set-time '2018-12-16 13:45'",
              "systemctl start restic-backups-remotebackup.service",
              '${pkgs.restic}/bin/restic -r ${repository} -p ${passwordFile} snapshots -c | grep -e "^4 snapshot"',
          )
        '';
      }
)
