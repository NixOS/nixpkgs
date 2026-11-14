{
  lib,
  runTest,
  ...
}:

let
  testBase =
    { config, pkgs, ... }:
    {
      imports = [
        {
          options.test-helpers = {
            init = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            provision = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            extraTests = lib.mkOption {
              type = lib.types.either lib.types.str (lib.types.functionTo lib.types.str);
              default = "";
            };
          };
          options.adminuser = lib.mkOption { type = lib.types.str; };
          options.adminpass = lib.mkOption { type = lib.types.str; };
        }
      ];

      adminuser = lib.mkDefault "root";
      # This needs to be a "secure" password, since the password_policy app is enabled after installation and will forbid "simple" passwords.
      adminpass = lib.mkDefault "+CVpTwaOEktxsFc6";

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
            };
          };
      };

      testScript =
        args@{ nodes, ... }:
        let
          inherit (config) test-helpers;
          rclone = "${pkgs.writeShellScript "rclone" ''
            set -euo pipefail
            export PATH="${pkgs.rclone}/bin:$PATH"
            export RCLONE_CONFIG_NEXTCLOUD_TYPE=webdav
            export RCLONE_CONFIG_NEXTCLOUD_URL="http://nextcloud/remote.php/dav/files/${config.adminuser}"
            export RCLONE_CONFIG_NEXTCLOUD_VENDOR="nextcloud"
            export RCLONE_CONFIG_NEXTCLOUD_USER="${config.adminuser}"
            export RCLONE_CONFIG_NEXTCLOUD_PASS="$(rclone obscure ${config.adminpass})"
            exec "$@"
          ''}";

          upload-sample = "${pkgs.writeShellScript "rclone-upload" ''
            <<<'hi' rclone rcat nextcloud:test-shared-file
          ''}";
          check-sample = "${pkgs.writeShellScript "check-sample" ''
            set -e
            diff <(echo 'hi') <(rclone cat nextcloud:test-shared-file)
          ''}";
        in
        lib.mkBefore ''
          ${test-helpers.provision}
          start_all()
          nextcloud.wait_for_unit("multi-user.target")

          nextcloud.succeed("NC_PASS=${config.adminpass} nextcloud-occ user:add ${config.adminuser} --password-from-env")
          nextcloud.succeed("nextcloud-occ group:adduser admin ${config.adminuser}")

          ${test-helpers.init}

          with subtest("Ensure nextcloud-occ is working"):
              nextcloud.succeed("nextcloud-occ status")
              nextcloud.succeed("curl -sSf http://nextcloud/login")

          with subtest("Upload/Download test"):
              nextcloud.succeed(
                  "${rclone} ${upload-sample}"
              )
              client.wait_for_unit("multi-user.target")
              client.succeed(
                  "${rclone} ${check-sample}"
              )

          ${
            if lib.isFunction test-helpers.extraTests then
              test-helpers.extraTests args
            else
              test-helpers.extraTests
          }
        '';
    };

  packages = lib.listToAttrs (
    map
      (
        version:
        let
          attr = "nextcloud${toString version}";
        in
        lib.nameValuePair attr (builtins.getAttr attr)
      )
      [
        33
        34
        35
      ]
  );

  genTests =
    attr: package:
    lib.mapAttrs
      (
        name: path:
        runTest (
          import path {
            inherit
              testBase
              package
              runTest
              ;
            name = "${attr}-${name}";
          }
        )
      )
      {
        basic = ./basic.nix;
        home-bindmout = ./home-bindmount.nix;
        home-mount = ./home-mount.nix;
        with-declarative-redis-and-secrets = ./with-declarative-redis-and-secrets.nix;
        with-mysql-and-memcached = ./with-mysql-and-memcached.nix;
        with-postgresql-and-redis = ./with-postgresql-and-redis.nix;
        with-objectstore = ./with-objectstore.nix;
        with-mail = ./with-mail.nix;
      };
in
lib.mapAttrs genTests packages
