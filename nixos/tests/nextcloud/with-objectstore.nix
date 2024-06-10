args@{ pkgs, nextcloudVersion ? 28, ... }:

(import ../make-test-python.nix ({ pkgs, ...}: let
  adminpass = "hunter2";
  adminuser = "root";

  accessKey = "BKIKJAA5BMMU2RHO6IBB";
  secretKey = "V7f1CwQqAcwo80UEIJEjc5gVQUSSx5ohQ9GSrr12";

  rootCredentialsFile = pkgs.writeText "minio-credentials-full" ''
    MINIO_ROOT_USER=${accessKey}
    MINIO_ROOT_PASSWORD=${secretKey}
  '';

in {
  name = "nextcloud-with-objectstore";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ onny ma27 ];
  };

  nodes = {
    # The only thing the client needs to do is download a file.
    client = { ... }: {};

    nextcloud = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 9000 ];
      environment.systemPackages = [ pkgs.minio-client ];

      services.nextcloud = {
        enable = true;
        hostName = "nextcloud";
        package = pkgs.${"nextcloud" + (toString nextcloudVersion)};
        database.createLocally = true;
        # Don't try this at home!
        config.adminpassFile = "${pkgs.writeText "adminpass" adminpass}";
        config.objectstore.s3 = {
          enable = true;
          bucket = "nextcloud";
          autocreate = false;
          key = accessKey;
          secretFile = "${pkgs.writeText "secretKey" secretKey}";
          hostname = "nextcloud";
          useSsl = false;
          port = 9000;
          usePathStyle = true;
          region = "us-east-1";
        };
      };

      services.minio = {
        enable = true;
        listenAddress = "0.0.0.0:9000";
        consoleAddress = "0.0.0.0:9001";
        inherit rootCredentialsFile;
      };

    };
  };

  testScript = let
    withRcloneEnv = pkgs.writeScript "with-rclone-env" ''
      #!${pkgs.runtimeShell}
      export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
      export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/dav/files/${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
      export RCLONE_CONFIG_NEXTCLOUD_USER="${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_PASS="$(${pkgs.rclone}/bin/rclone obscure ${adminpass})"
      "''${@}"
    '';
    copySharedFile = pkgs.writeScript "copy-shared-file" ''
      #!${pkgs.runtimeShell}
      set -euxo pipefail
      echo 'hello world' | ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file
    '';

    diffSharedFile = pkgs.writeScript "diff-shared-file" ''
      #!${pkgs.runtimeShell}
      set -euxo pipefail
      diff <(echo 'hello world') <(${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file)
    '';
  in ''
    start_all()
    nextcloud.wait_for_unit("multi-user.target")
    nextcloud.wait_for_unit("minio.service")
    nextcloud.wait_for_open_port(9000)
    nextcloud.succeed(
        "mc config host add minio http://localhost:9000 ${accessKey} ${secretKey} --api s3v4"
    )
    nextcloud.succeed("mc mb minio/nextcloud")
    nextcloud.succeed("curl -sSf http://nextcloud/login")

    client.wait_for_unit("multi-user.target")
    client.succeed(
        "${withRcloneEnv} ${copySharedFile}"
    )
    nextcloud.succeed("${withRcloneEnv} ${diffSharedFile}")
    client.wait_until_succeeds(
        "${withRcloneEnv} ${diffSharedFile}"
    )

    nextcloud.succeed("mc ls --recursive minio >&2")
  '';
})) args
