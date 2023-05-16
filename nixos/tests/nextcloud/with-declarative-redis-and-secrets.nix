<<<<<<< HEAD
args@{ nextcloudVersion ? 27, ... }:
(import ../make-test-python.nix ({ pkgs, ...}: let
  adminuser = "custom_admin_username";
=======
import ../make-test-python.nix ({ pkgs, ...}: let
  username = "custom_admin_username";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  # This will be used both for redis and postgresql
  pass = "hunter2";
  # Don't do this at home, use a file outside of the nix store instead
  passFile = toString (pkgs.writeText "pass-file" ''
    ${pass}
  '');
in {
  name = "nextcloud-with-declarative-redis";
  meta = with pkgs.lib.maintainers; {
<<<<<<< HEAD
    maintainers = [ eqyiel ma27 ];
=======
    maintainers = [ eqyiel ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nodes = {
    # The only thing the client needs to do is download a file.
    client = { ... }: {};

    nextcloud = { config, pkgs, ... }: {
      networking.firewall.allowedTCPPorts = [ 80 ];

      services.nextcloud = {
        enable = true;
        hostName = "nextcloud";
<<<<<<< HEAD
        package = pkgs.${"nextcloud" + (toString nextcloudVersion)};
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        caching = {
          apcu = false;
          redis = true;
          memcached = false;
        };
        # This test also validates that we can use an "external" database
        database.createLocally = false;
        config = {
          dbtype = "pgsql";
          dbname = "nextcloud";
<<<<<<< HEAD
          dbuser = adminuser;
          dbpassFile = passFile;
          adminuser = adminuser;
=======
          dbuser = username;
          dbpassFile = passFile;
          adminuser = username;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          adminpassFile = passFile;
        };
        secretFile = "/etc/nextcloud-secrets.json";

        extraOptions.redis = {
<<<<<<< HEAD
=======
          host = "/run/redis/redis.sock";
          port = 0;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
          dbindex = 0;
          timeout = 1.5;
          # password handled via secretfile below
        };
<<<<<<< HEAD
        configureRedis = true;
      };

      services.redis.servers."nextcloud" = {
        enable = true;
        port = 6379;
        requirePass = "secret";
      };
=======
        extraOptions.memcache = {
          local = "\OC\Memcache\Redis";
          locking = "\OC\Memcache\Redis";
        };
      };

      services.redis.servers."nextcloud".enable = true;
      services.redis.servers."nextcloud".port = 6379;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

      systemd.services.nextcloud-setup= {
        requires = ["postgresql.service"];
        after = [ "postgresql.service" ];
      };

      services.postgresql = {
        enable = true;
      };
      systemd.services.postgresql.postStart = pkgs.lib.mkAfter ''
        password=$(cat ${passFile})
        ${config.services.postgresql.package}/bin/psql <<EOF
<<<<<<< HEAD
          CREATE ROLE ${adminuser} WITH LOGIN PASSWORD '$password' CREATEDB;
          CREATE DATABASE nextcloud;
          GRANT ALL PRIVILEGES ON DATABASE nextcloud TO ${adminuser};
=======
          CREATE ROLE ${username} WITH LOGIN PASSWORD '$password' CREATEDB;
          CREATE DATABASE nextcloud;
          GRANT ALL PRIVILEGES ON DATABASE nextcloud TO ${username};
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        EOF
      '';

      # This file is meant to contain secret options which should
      # not go into the nix store. Here it is just used to set the
<<<<<<< HEAD
      # redis password.
=======
      # databyse type to postgres.
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
      export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/dav/files/${adminuser}"
      export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
      export RCLONE_CONFIG_NEXTCLOUD_USER="${adminuser}"
=======
      export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/webdav/"
      export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
      export RCLONE_CONFIG_NEXTCLOUD_USER="${username}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      export RCLONE_CONFIG_NEXTCLOUD_PASS="$(${pkgs.rclone}/bin/rclone obscure ${pass})"
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
<<<<<<< HEAD
    nextcloud.fail('test "[]" = "$(redis-cli --json KEYS "*")"')
  '';
})) args
=======
    nextcloud.fail("redis-cli KEYS * | grep -q 'empty array'")
  '';
})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
