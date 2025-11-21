{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.radicle.ci.adapters.native;
  brokerCfg = config.services.radicle.ci.broker;

  settingsFormat = pkgs.formats.yaml { };

  enabledInstances = lib.filter (instance: instance.enable) (lib.attrValues cfg.instances);
in

{
  meta.maintainers = with lib.maintainers; [ defelo ];

  options.services.radicle.ci.adapters.native = {
    instances = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { config, name, ... }:
          {
            options = {
              enable = lib.mkEnableOption "this radicle-native-ci instance" // {
                default = true;
                example = false;
              };

              name = lib.mkOption {
                type = lib.types.str;
                description = ''
                  Adapter name that is used in the radicle-ci-broker configuration.
                  Defaults to the attribute name.
                '';
              };

              package = lib.mkPackageOption pkgs "radicle-native-ci" { };

              runtimePackages = lib.mkOption {
                type = lib.types.listOf lib.types.package;
                description = "Packages added to the adapter's {env}`PATH`.";
                defaultText = lib.literalExpression ''
                  with pkgs; [
                    bash
                    coreutils
                    curl
                    gawk
                    gitMinimal
                    gnused
                    wget
                  ]
                '';
              };

              settings = lib.mkOption {
                type = lib.types.submodule {
                  freeformType = settingsFormat.type;

                  options = {
                    state = lib.mkOption {
                      type = lib.types.path;
                      description = "Directory where per-run directories are stored.";
                      defaultText = lib.literalExpression ''"''${config.services.radicle.ci.broker.stateDir}/adapters/native/${config.name}"'';
                    };

                    log = lib.mkOption {
                      type = lib.types.path;
                      description = "File where radicle-native-ci should write the run log.";
                      defaultText = lib.literalExpression ''"''${config.services.radicle.ci.broker.logDir}/adapters/native/${config.name}.log"'';
                    };

                    base_url = lib.mkOption {
                      type = lib.types.nullOr lib.types.str;
                      description = "Base URL for build logs (mandatory for access from CI broker page).";
                      default = null;
                    };
                  };
                };
                description = ''
                  Configuration of radicle-native-ci.
                  See <https://app.radicle.xyz/nodes/seed.radicle.xyz/rad:z3qg5TKmN83afz2fj9z3fQjU8vaYE#configuration> for more information.
                '';
                default = { };
              };
            };

            config = {
              name = lib.mkDefault name;

              runtimePackages = with pkgs; [
                bash
                coreutils
                curl
                gawk
                gitMinimal
                gnused
                wget
              ];

              settings = {
                state = lib.mkDefault "${brokerCfg.stateDir}/adapters/native/${config.name}";
                log = lib.mkDefault "${brokerCfg.logDir}/adapters/native/${config.name}.log";
              };
            };
          }
        )
      );
      description = "radicle-native-ci adapter instances.";
      default = { };
    };
  };

  config = lib.mkIf (enabledInstances != [ ]) {
    services.radicle.ci.broker.settings.adapters = lib.listToAttrs (
      map (
        instance:
        lib.nameValuePair instance.name {
          command = lib.getExe instance.package;
          config = instance.settings;
          config_env = "RADICLE_NATIVE_CI";
          env.PATH = lib.makeBinPath instance.runtimePackages;
        }
      ) enabledInstances
    );

    systemd.tmpfiles.settings.radicle-native-ci = lib.listToAttrs (
      map (
        instance:
        lib.nameValuePair (builtins.dirOf instance.settings.log) {
          d = {
            user = config.users.users.radicle.name;
            group = config.users.groups.radicle.name;
          };
        }
      ) enabledInstances
    );
  };
}
