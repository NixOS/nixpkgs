args@{
  pkgs,
  nextcloudVersion ? 22,
  ...
}:

(import ../make-test-python.nix (
  { pkgs, ... }:
  let
    adminpass = "hunter2";
    adminuser = "root";
  in
  {
    name = "nextcloud-with-mysql-and-memcached";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ eqyiel ];
    };

    nodes = {
      # The only thing the client needs to do is download a file.
      client = { ... }: { };

      nextcloud =
        { config, pkgs, ... }:
        {
          networking.firewall.allowedTCPPorts = [ 80 ];

          services.nextcloud = {
            enable = true;
            hostName = "nextcloud";
            https = true;
            package = pkgs.${"nextcloud" + (toString nextcloudVersion)};
            caching = {
              apcu = true;
              redis = false;
              memcached = true;
            };
            database.createLocally = true;
            config = {
              dbtype = "mysql";
              # Don't inherit adminuser since "root" is supposed to be the default
              adminpassFile = "${pkgs.writeText "adminpass" adminpass}"; # Don't try this at home!
            };
          };

          services.memcached.enable = true;
        };
    };

    testScript =
      let
        configureMemcached = pkgs.writeScript "configure-memcached" ''
          #!${pkgs.runtimeShell}
          nextcloud-occ config:system:set memcached_servers 0 0 --value 127.0.0.1 --type string
          nextcloud-occ config:system:set memcached_servers 0 1 --value 11211 --type integer
          nextcloud-occ config:system:set memcache.local --value '\OC\Memcache\APCu' --type string
          nextcloud-occ config:system:set memcache.distributed --value '\OC\Memcache\Memcached' --type string
        '';
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
          echo 'hi' | ${pkgs.rclone}/bin/rclone rcat nextcloud:test-shared-file
        '';

        diffSharedFile = pkgs.writeScript "diff-shared-file" ''
          #!${pkgs.runtimeShell}
          diff <(echo 'hi') <(${pkgs.rclone}/bin/rclone cat nextcloud:test-shared-file)
        '';
      in
      ''
        start_all()
        nextcloud.wait_for_unit("multi-user.target")
        nextcloud.succeed("${configureMemcached}")
        nextcloud.succeed("curl -sSf http://nextcloud/login")
        nextcloud.succeed(
            "${withRcloneEnv} ${copySharedFile}"
        )
        client.wait_for_unit("multi-user.target")
        client.succeed(
            "${withRcloneEnv} ${diffSharedFile}"
        )
      '';
  }
))
  args
