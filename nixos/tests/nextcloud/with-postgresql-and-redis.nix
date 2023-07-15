args@{ pkgs, nextcloudVersion ? 22, ... }:

(import ../make-test-python.nix ({ pkgs, ...}: let
  adminpass = "hunter2";
  adminuser = "custom-admin-username";
in {
  name = "nextcloud-with-postgresql-and-redis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eqyiel ];
  };

  nodes = {
    # The only thing the client needs to do is download a file.
    client = { ... }: {};

    nextcloud = { config, pkgs, lib, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.nextcloud = {
        enable = true;
        hostName = "nextcloud";
        package = pkgs.${"nextcloud" + (toString nextcloudVersion)};
        caching = {
          apcu = false;
          redis = true;
          memcached = false;
        };
        database.createLocally = true;
        config = {
          dbtype = "pgsql";
          inherit adminuser;
          adminpassFile = toString (pkgs.writeText "admin-pass-file" ''
            ${adminpass}
          '');
          trustedProxies = [ "::1" ];
        };
        notify_push = {
          enable = true;
          logLevel = "debug";
        };
        extraAppsEnable = true;
        extraApps = {
          inherit (pkgs."nextcloud${lib.versions.major config.services.nextcloud.package.version}Packages".apps) notify_push;
        };
      };

      services.redis.servers."nextcloud".enable = true;
      services.redis.servers."nextcloud".port = 6379;
    };
  };

  testScript = let
    configureRedis = pkgs.writeScript "configure-redis" ''
      #!${pkgs.runtimeShell}
      nextcloud-occ config:system:set redis 'host' --value 'localhost' --type string
      nextcloud-occ config:system:set redis 'port' --value 6379 --type integer
      nextcloud-occ config:system:set memcache.local --value '\OC\Memcache\Redis' --type string
      nextcloud-occ config:system:set memcache.locking --value '\OC\Memcache\Redis' --type string
    '';
    withRcloneEnv = pkgs.writeScript "with-rclone-env" ''
      #!${pkgs.runtimeShell}
      export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
      export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/webdav/"
      export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
      export RCLONE_CONFIG_NEXTCLOUD_USER="${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_PASS="$(${pkgs.rclone}/bin/rclone obscure ${adminpass})"
      "''${@}"
    '';
    copySharedFile = pkgs.writeScript "copy-shared-file" ''
      #!${pkgs.runtimeShell}
      echo 'hi' | ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file
    '';

    diffSharedFile = pkgs.writeScript "diff-shared-file" ''
      #!${pkgs.runtimeShell}
      diff <(echo 'hi') <(${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file)
    '';
  in ''
    start_all()
    nextcloud.wait_for_unit("multi-user.target")
    nextcloud.succeed("${configureRedis}")
    nextcloud.succeed("curl -sSf http://nextcloud/login")
    nextcloud.succeed(
        "${withRcloneEnv} ${copySharedFile}"
    )
    client.wait_for_unit("multi-user.target")
    client.execute("${pkgs.nextcloud-notify_push.passthru.test_client}/bin/test_client http://nextcloud ${adminuser} ${adminpass} >&2 &")
    client.succeed(
        "${withRcloneEnv} ${diffSharedFile}"
    )
    nextcloud.wait_until_succeeds("journalctl -u nextcloud-notify_push | grep -q \"Sending ping to ${adminuser}\"")

    # redis cache should not be empty
    nextcloud.fail('test "[]" = "$(redis-cli --json KEYS "*")"')
  '';
})) args
