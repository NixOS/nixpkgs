import ../make-test-python.nix ({ pkgs, ...}: let
  adminpass = "hunter2";
  adminuser = "custom-admin-username";
in {
  name = "nextcloud-with-declarative-redis";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ eqyiel ];
  };

  nodes = {
    # The only thing the client needs to do is download a file.
    client = { ... }: {};

    nextcloud = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.nextcloud = {
        enable = true;
        hostName = "nextcloud";
        caching = {
          apcu = false;
          redis = true;
          memcached = false;
        };
        config = {
          dbtype = "pgsql";
          dbname = "nextcloud";
          dbuser = "nextcloud";
          dbhost = "/run/postgresql";
          inherit adminuser;
          adminpassFile = toString (pkgs.writeText "admin-pass-file" ''
            ${adminpass}
          '');
        };
        secretFile = "/etc/nextcloud-secrets.json";

        extraOptions.redis = {
          host = "/run/redis/redis.sock";
          port = 0;
          dbindex = 0;
          timeout = 1.5;
          # password handled via secretfile below
        };
        extraOptions.memcache = {
          local = "\OC\Memcache\Redis";
          locking = "\OC\Memcache\Redis";
        };
      };

      services.redis = {
        enable = true;
      };

      systemd.services.nextcloud-setup= {
        requires = ["postgresql.service"];
        after = [
          "postgresql.service"
        ];
      };

      services.postgresql = {
        enable = true;
        ensureDatabases = [ "nextcloud" ];
        ensureUsers = [
          { name = "nextcloud";
            ensurePermissions."DATABASE nextcloud" = "ALL PRIVILEGES";
          }
        ];
      };

      # This file is meant to contain secret options which should
      # not go into the nix store. Here it is just used to set the
      # databyse type to postgres.
      environment.etc."nextcloud-secrets.json".text = ''
        {
          "redis": {
            "password": "secret"
          }
        }
      '';
    };
  };

  testScript = let
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
    nextcloud.succeed("curl -sSf http://nextcloud/login")
    nextcloud.succeed(
        "${withRcloneEnv} ${copySharedFile}"
    )
    client.wait_for_unit("multi-user.target")
    client.succeed(
        "${withRcloneEnv} ${diffSharedFile}"
    )

    # redis cache should not be empty
    nextcloud.fail("redis-cli KEYS * | grep -q 'empty array'")
  '';
})
