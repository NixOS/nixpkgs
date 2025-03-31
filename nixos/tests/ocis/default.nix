{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../../.. { inherit system config; },
}:

let
  inherit (pkgs.lib)
    listToAttrs
    concatMap
    optionalString
    nameValuePair
    mkBefore
    getExe
    isFunction
    removeSuffix
    mkOption
    types
    ;

  baseModule =
    pkg:
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

          options.adminUser = mkOption { type = types.str; };
          options.adminPassword = mkOption { type = types.str; };
          options.demoUser = mkOption { type = types.str; };
          options.demoPassword = mkOption { type = types.str; };
        }
      ];

      # this is a demo user created by IDM_CREATE_DEMO_USERS=true
      demoUser = "einstein";
      demoPassword = "relativity";
      adminUser = "admin";
      adminPassword = "hunter2";

      test-helpers.rclone = "${pkgs.writeShellScript "rclone" ''
        set -euo pipefail
        export PATH="${pkgs.rclone}/bin:$PATH"
        export RCLONE_CONFIG_OCIS_TYPE=webdav
        export RCLONE_CONFIG_OCIS_VENDOR=owncloud
        export RCLONE_CONFIG_OCIS_URL=https://ocis:9200/remote.php/webdav/
        export RCLONE_CONFIG_OCIS_USER="${config.demoUser}"
        export RCLONE_CONFIG_OCIS_PASS=$(rclone obscure ${config.demoPassword})
        export RCLONE_LOG_LEVEL=DEBUG
        exec "$@"
      ''}";

      test-helpers.upload-sample = "${pkgs.writeShellScript "rclone-upload" ''
        set -euo pipefail
        echo 'hi' | rclone --no-check-certificate rcat ocis:/test-shared-file
      ''}";
      test-helpers.check-sample = "${pkgs.writeShellScript "check-sample" ''
        set -euo pipefail
        diff <(echo 'hi') <(rclone --no-check-certificate cat ocis:/test-shared-file)
      ''}";

      nodes = {
        client = { ... }: { };
        ocis = { ... }: { };
      };
      testScript =
        args@{ nodes, ... }:
        let
          inherit (config) test-helpers;
        in
        mkBefore ''
          ocis.start()
          client.start()
          ocis.wait_for_unit("multi-user.target")
          ocis.wait_for_open_port(9200)

          with subtest("ocis is online"):
              ocis.wait_until_succeeds("${getExe pkgs.${pkg}} version")

          ${test-helpers.init}

          with subtest("ocisadm works"):
              print(ocis.succeed("ocisadm version"))

          with subtest("Upload/Download test"):
              ocis.succeed(
                  "${test-helpers.rclone} ${test-helpers.upload-sample}"
              )
              client.wait_for_unit("multi-user.target")
              client.succeed(
                  "${test-helpers.rclone} ${test-helpers.check-sample}"
              )

          ${

            if isFunction test-helpers.extraTests then test-helpers.extraTests args else test-helpers.extraTests
          }
        '';
    };

  genTests =
    pkg:
    let
      testBase.imports = [
        (baseModule pkg)
        {
          nodes.ocis =
            { pkgs, ... }:
            {
              services.ocis.package = pkgs.${pkg};
            };
        }
      ];

      callOCISTest =
        path:
        let
          name = "${removeSuffix ".nix" (baseNameOf path)}-${pkg}";
        in
        nameValuePair name (
          import path {
            inherit system pkgs testBase;
            name = "ocis-${name}";
          }
        );
    in
    map callOCISTest [
      ./basic.nix
    ];
in
listToAttrs (
  concatMap genTests [
    "ocis_5-bin"
    "ocis_70-bin"
    "ocis_71-bin"
  ]
)
