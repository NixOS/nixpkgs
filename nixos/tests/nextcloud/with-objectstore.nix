args@{ pkgs, nextcloudVersion ? 28, ... }:

(import ../make-test-python.nix ({ pkgs, ...}: let
  adminpass = "hunter2";
  adminuser = "root";

  accessKey = "nextcloud";
  secretKey = "test12345";

  rootCredentialsFile = pkgs.writeText "minio-credentials-full" ''
    MINIO_ROOT_USER=${accessKey}
    MINIO_ROOT_PASSWORD=${secretKey}
  '';

in {
  name = "nextcloud-with-objectstore";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ onny ];
  };

  nodes = {
    # The only thing the client needs to do is download a file.
    client = { ... }: {};

    nextcloud = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 9000 ];

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
          autocreate = true;
          key = "nextcloud";
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
    '';
    copySharedFile = pkgs.writeScript "copy-shared-file" ''
      #!${pkgs.runtimeShell}
      echo 'hello world' | ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file
    '';

    diffSharedFile = pkgs.writeScript "diff-shared-file" ''
      #!${pkgs.runtimeShell}
      export AWS_ACCESS_KEY_ID=${accessKey}
      export AWS_SECRET_ACCESS_KEY=${secretKey}
      ${pkgs.awscli2}/bin/aws s3 cp s3://nextcloud /tmp/. --recursive --endpoint-url http://nextcloud:9000 --region us-east-1
      grep -r "hello world" /tmp
    '';
  in ''
    start_all()
    nextcloud.wait_for_unit("multi-user.target")
    nextcloud.wait_for_unit("minio.service")
    nextcloud.wait_for_open_port(9000)
    nextcloud.succeed("curl -sSf http://nextcloud/login")
    nextcloud.succeed(
        "${withRcloneEnv} ${copySharedFile}"
    )
    client.wait_for_unit("multi-user.target")
    client.wait_until_succeeds(
        "${diffSharedFile}"
    )
  '';
})) args
