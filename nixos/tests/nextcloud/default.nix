{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

with pkgs.lib;

let
  baseModule =
    { config, ... }:
    {
      imports = [
        {
          options.test-helpers = {
            rclone = mkOption { type = types.str; };
            upload-sample = mkOption { type = types.str; };
            check-sample = mkOption { type = types.str; };
            init = mkOption {
              type = types.str;
              default = "";
            };
            extraTests = mkOption {
              type = types.either types.str (types.functionTo types.str);
              default = "";
            };
          };
          options.adminuser = mkOption { type = types.str; };
          options.adminpass = mkOption { type = types.str; };
        }
      ];

      adminuser = pkgs.lib.mkDefault "root";
      adminpass = pkgs.lib.mkDefault "hunter2";

      test-helpers.rclone = "${pkgs.writeShellScript "rclone" ''
        set -euo pipefail
        export PATH="${pkgs.rclone}/bin:$PATH"
        export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
        export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/dav/files/${config.adminuser}"
        export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
        export RCLONE_CONFIG_NEXTCLOUD_USER="${config.adminuser}"
        export RCLONE_CONFIG_NEXTCLOUD_PASS="$(rclone obscure ${config.adminpass})"
        exec "$@"
      ''}";
      test-helpers.upload-sample = "${pkgs.writeShellScript "rclone-upload" ''
        <<<'hi' rclone rcat nextcloud:test-shared-file
      ''}";
      test-helpers.check-sample = "${pkgs.writeShellScript "check-sample" ''
        set -e
        diff <(echo 'hi') <(rclone cat nextcloud:test-shared-file)
      ''}";

      nodes = {
        client = { ... }: { };
        nextcloud =
          { lib, ... }:
          {
            networking.firewall.allowedTCPPorts = [ 80 ];
            services.nextcloud = {
              enable = true;
              hostName = "nextcloud";
              https = false;
              database.createLocally = lib.mkDefault true;
              config = {
                adminpassFile = "${pkgs.writeText "adminpass" config.adminpass}"; # Don't try this at home!
              };
            };
          };
      };

      testScript =
        args@{ nodes, ... }:
        let
          inherit (config) test-helpers;
        in
        mkBefore ''
          nextcloud.start()
          client.start()
          nextcloud.wait_for_unit("multi-user.target")

          ${test-helpers.init}

          with subtest("Ensure nextcloud-occ is working"):
              nextcloud.succeed("nextcloud-occ status")
              nextcloud.succeed("curl -sSf http://nextcloud/login")

          with subtest("Upload/Download test"):
              nextcloud.succeed(
                  "${test-helpers.rclone} ${test-helpers.upload-sample}"
              )
              client.wait_for_unit("multi-user.target")
              client.succeed(
                  "${test-helpers.rclone} ${test-helpers.check-sample}"
              )

          ${
            if pkgs.lib.isFunction test-helpers.extraTests then
              test-helpers.extraTests args
            else
              test-helpers.extraTests
          }
        '';
    };

  genTests =
    version:
    let
      testBase.imports = [
        baseModule
        {
          nodes.nextcloud =
            { pkgs, ... }:
            {
              services.nextcloud.package = pkgs.${"nextcloud${toString version}"};
            };
        }
      ];

      callNextcloudTest =
        path:
        let
          name = "${removeSuffix ".nix" (baseNameOf path)}${toString version}";
        in
        nameValuePair name (
          import path {
            inherit system pkgs testBase;
            name = "nextcloud-${name}";
          }
        );
    in
    map callNextcloudTest (
      [
        ./basic.nix
        ./with-declarative-redis-and-secrets.nix
        ./with-mysql-and-memcached.nix
        ./with-postgresql-and-redis.nix
        ./with-objectstore.nix
      ]
      ++ (pkgs.lib.optional (version >= 32) ./without-admin-user.nix)
    );
in
listToAttrs (
  concatMap genTests [
    31
    32
  ]
)
