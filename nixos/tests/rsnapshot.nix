{ pkgs, lib, ... }:

let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey
    snakeOilPublicKey
    snakeOilEd25519PrivateKey
    snakeOilEd25519PublicKey
    ;

  localDir = "/data/local";
  localFile = "keep.txt";
  localFileData = "This file should be backed up locally.";

  remoteDir = "/data/remote";
  remoteFile = "keep.txt";
  remoteFileData = "This file should be backed up over ssh.";

  snapshotRoot = "/var/cache/rsnapshot";
in
{
  name = "rsnapshot";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  containers.backup = {
    systemd.tmpfiles.settings."10-rsnapshot-test" = {
      ${localDir}.d.mode = "0700";
      "${localDir}/${localFile}".f = {
        mode = "0644";
        argument = localFileData;
      };
      ${snapshotRoot}.d.mode = "0700";
    };

    programs.ssh = {
      systemd-ssh-proxy.enable = false;
      knownHosts.server = {
        hostNames = [ "server" ];
        publicKey = snakeOilPublicKey;
      };
      extraConfig = ''
        Host server
          IdentityFile ${snakeOilEd25519PrivateKey}
      '';
    };

    services.rsnapshot = {
      enable = true;
      extraConfig = ''
        snapshot_root	${snapshotRoot}/
        retain	daily	6
        backup	${localDir}/	localhost/
        backup	root@server:${remoteDir}/	server/
      '';
    };
  };

  containers.server = {
    systemd.tmpfiles.settings."10-rsnapshot-test" = {
      ${remoteDir}.d.mode = "0700";
      "${remoteDir}/${remoteFile}".f = {
        mode = "0644";
        argument = remoteFileData;
      };
    };

    services.openssh = {
      enable = true;
      hostKeys = [
        {
          type = "ecdsa";
          path = "${snakeOilPrivateKey}";
        }
      ];
    };

    users.users.root.openssh.authorizedKeys.keys = [ snakeOilEd25519PublicKey ];
  };

  testScript = ''
    start_all()

    backup.wait_for_unit("multi-user.target")
    server.wait_for_unit("multi-user.target")
    server.wait_for_open_port(22)

    backup.succeed("rsnapshot -c /etc/rsnapshot.conf daily")

    with subtest("Local directory is backed up"):
        backup.succeed(
            "test -f ${snapshotRoot}/daily.0/localhost${localDir}/${localFile}"
        )
        assert "${localFileData}" in backup.succeed(
            "cat ${snapshotRoot}/daily.0/localhost${localDir}/${localFile}"
        )

    with subtest("Remote directory is backed up"):
        backup.succeed(
            "test -f ${snapshotRoot}/daily.0/server${remoteDir}/${remoteFile}"
        )
        assert "${remoteFileData}" in backup.succeed(
            "cat ${snapshotRoot}/daily.0/server${remoteDir}/${remoteFile}"
        )
  '';
}
