{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.vdirsyncer;

  toIniJson = with generators; toINI {
    mkKeyValue = mkKeyValueDefault {
      mkValueString = builtins.toJSON;
    } "=";
  };

  toConfigFile = name: cfg':
    if
      cfg'.configFile != null
    then
      cfg'.configFile
    else
      pkgs.writeText "vdirsyncer-${name}.conf" (toIniJson (
        {
          general = cfg'.config.general // (lib.optionalAttrs (cfg'.config.statusPath == null) {
            status_path = "/var/lib/vdirsyncer/${name}";
          });
        } // (
          mapAttrs' (name: nameValuePair "pair ${name}") cfg'.config.pairs
        ) // (
          mapAttrs' (name: nameValuePair "storage ${name}") cfg'.config.storages
        )
      ));

  userUnitConfig = name: cfg': {
    serviceConfig = {
      User = if cfg'.user == null then "vdirsyncer" else cfg'.user;
      Group = if cfg'.group == null then "vdirsyncer" else cfg'.group;
    }  // (optionalAttrs (cfg'.user == null) {
      DynamicUser = true;
    }) // (optionalAttrs (cfg'.additionalGroups != []) {
      SupplementaryGroups = cfg'.additionalGroups;
    }) // (optionalAttrs (cfg'.config.statusPath == null) {
      StateDirectory = "vdirsyncer/${name}";
      StateDirectoryMode = "0700";
    });
  };

  commonUnitConfig = {
    after = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      # Sandboxing
      PrivateTmp = true;
      NoNewPrivileges = true;
      ProtectSystem = "strict";
      ProtectHome = true;
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictNamespaces = true;
      MemoryDenyWriteExecute = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      RestrictAddressFamilies = "AF_INET AF_INET6";
      LockPersonality = true;
    };
  };

in
{
  options = {
    services.vdirsyncer = {
      enable = mkEnableOption (mdDoc "vdirsyncer");

      package = mkPackageOptionMD pkgs "vdirsyncer" {};

      jobs = mkOption {
        description = mdDoc "vdirsyncer job configurations";
        type = types.attrsOf (types.submodule {
          options = {
            enable = (mkEnableOption (mdDoc "this vdirsyncer job")) // {
              default = true;
              example = false;
            };

            user = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = mdDoc ''
                User account to run vdirsyncer as, otherwise as a systemd
                dynamic user
              '';
            };

            group = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = mdDoc "group to run vdirsyncer as";
            };

            additionalGroups = mkOption {
              type = types.listOf types.str;
              default = [];
              description = mdDoc "additional groups to add the dynamic user to";
            };

            forceDiscover = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                Run `yes | vdirsyncer discover` prior to `vdirsyncer sync`
              '';
            };

            timerConfig = mkOption {
              type = types.attrs;
              default = {
                OnBootSec = "1h";
                OnUnitActiveSec = "6h";
              };
              description = mdDoc "systemd timer configuration";
            };

            configFile = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = mdDoc "existing configuration file";
            };

            config = {
              statusPath = mkOption {
                type = types.nullOr types.str;
                default = null;
                defaultText = literalExpression "/var/lib/vdirsyncer/\${attrName}";
                description = mdDoc "vdirsyncer's status path";
              };

              general = mkOption {
                type = types.attrs;
                default = {};
                description = mdDoc "general configuration";
              };

              pairs = mkOption {
                type = types.attrsOf types.attrs;
                default = {};
                description = mdDoc "vdirsyncer pair configurations";
                example = literalExpression ''
                  {
                    my_contacts = {
                      a = "my_cloud_contacts";
                      b = "my_local_contacts";
                      collections = [ "from a" ];
                      conflict_resolution = "a wins";
                      metadata = [ "color" "displayname" ];
                    };
                  };
                '';
              };

              storages = mkOption {
                type = types.attrsOf types.attrs;
                default = {};
                description = mdDoc "vdirsyncer storage configurations";
                example = literalExpression ''
                  {
                    my_cloud_contacts = {
                      type = "carddav";
                      url = "https://dav.example.com/";
                      read_only = true;
                      username = "user";
                      "password.fetch" = [ "command" "cat" "/etc/vdirsyncer/cloud.passwd" ];
                    };
                    my_local_contacts = {
                      type = "carddav";
                      url = "https://localhost/";
                      username = "user";
                      "password.fetch" = [ "command" "cat" "/etc/vdirsyncer/local.passwd" ];
                    };
                  }
                '';
              };
            };
          };
        });
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services = mapAttrs' (name: cfg': nameValuePair "vdirsyncer@${name}" (
      foldr recursiveUpdate {} [
        commonUnitConfig
        (userUnitConfig name cfg')
        {
          description = "synchronize calendars and contacts (${name})";
          environment.VDIRSYNCER_CONFIG = toConfigFile name cfg';
          serviceConfig.ExecStart =
            (optional cfg'.forceDiscover (
              pkgs.writeShellScript "vdirsyncer-discover-yes" ''
                set -e
                yes | ${cfg.package}/bin/vdirsyncer discover
              ''
            )) ++ [ "${cfg.package}/bin/vdirsyncer sync" ];
        }
      ]
    )) (filterAttrs (name: cfg': cfg'.enable) cfg.jobs);

    systemd.timers = mapAttrs' (name: cfg': nameValuePair "vdirsyncer@${name}" {
      wantedBy = [ "timers.target" ];
      description = "synchronize calendars and contacts (${name})";
      inherit (cfg') timerConfig;
    }) cfg.jobs;
  };
}
