{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.vdirsyncer;

  toIniJson =
    lib.generators.toINI {
      mkKeyValue = lib.mkKeyValueDefault {
        mkValueString = builtins.toJSON;
      } "=";
    };

  toConfigFile =
    name: cfg':
    if cfg'.configFile != null then
      cfg'.configFile
    else
      pkgs.writeText "vdirsyncer-${name}.conf" (
        toIniJson (
          {
            general = cfg'.config.general // {
              status_path =
                if cfg'.config.statusPath == null then "/var/lib/vdirsyncer/${name}" else cfg'.config.statusPath;
            };
          }
          // (lib.mapAttrs' (name: lib.nameValuePair "pair ${name}") cfg'.config.pairs)
          // (lib.mapAttrs' (name: lib.nameValuePair "storage ${name}") cfg'.config.storages)
        )
      );

  userUnitConfig = name: cfg': {
    serviceConfig =
      {
        User = if cfg'.user == null then "vdirsyncer" else cfg'.user;
        Group = if cfg'.group == null then "vdirsyncer" else cfg'.group;
      }
      // (lib.optionalAttrs (cfg'.user == null) {
        DynamicUser = true;
      })
      // (lib.optionalAttrs (cfg'.additionalGroups != [ ]) {
        SupplementaryGroups = cfg'.additionalGroups;
      })
      // (lib.optionalAttrs (cfg'.config.statusPath == null) {
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
      enable = lib.mkEnableOption "vdirsyncer";

      package = lib.mkPackageOption pkgs "vdirsyncer" { };

      jobs = lib.mkOption {
        description = "vdirsyncer job configurations";
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              enable = (lib.mkEnableOption "this vdirsyncer job") // {
                default = true;
                example = false;
              };

              user = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  User account to run vdirsyncer as, otherwise as a systemd
                  dynamic user
                '';
              };

              group = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "group to run vdirsyncer as";
              };

              additionalGroups = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                description = "additional groups to add the dynamic user to";
              };

              forceDiscover = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Run `yes | vdirsyncer discover` prior to `vdirsyncer sync`
                '';
              };

              timerConfig = lib.mkOption {
                type = lib.types.attrs;
                default = {
                  OnBootSec = "1h";
                  OnUnitActiveSec = "6h";
                };
                description = "systemd timer configuration";
              };

              configFile = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = "existing configuration file";
              };

              config = {
                statusPath = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  defaultText = lib.literalExpression "/var/lib/vdirsyncer/\${attrName}";
                  description = "vdirsyncer's status path";
                };

                general = lib.mkOption {
                  type = lib.types.attrs;
                  default = { };
                  description = "general configuration";
                };

                pairs = lib.mkOption {
                  type = lib.types.attrsOf lib.types.attrs;
                  default = { };
                  description = "vdirsyncer pair configurations";
                  example = lib.literalExpression ''
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

                storages = lib.mkOption {
                  type = lib.types.attrsOf lib.types.attrs;
                  default = { };
                  description = "vdirsyncer storage configurations";
                  example = lib.literalExpression ''
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
          }
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services = lib.mapAttrs' (
      name: cfg':
      lib.nameValuePair "vdirsyncer@${name}" (
        lib.foldr lib.recursiveUpdate { } [
          commonUnitConfig
          (userUnitConfig name cfg')
          {
            description = "synchronize calendars and contacts (${name})";
            environment.VDIRSYNCER_CONFIG = toConfigFile name cfg';
            serviceConfig.ExecStart =
              (lib.optional cfg'.forceDiscover (
                pkgs.writeShellScript "vdirsyncer-discover-yes" ''
                  set -e
                  yes | ${cfg.package}/bin/vdirsyncer discover
                ''
              ))
              ++ [ "${cfg.package}/bin/vdirsyncer sync" ];
          }
        ]
      )
    ) (lib.filterAttrs (name: cfg': cfg'.enable) cfg.jobs);

    systemd.timers = lib.mapAttrs' (
      name: cfg':
      lib.nameValuePair "vdirsyncer@${name}" {
        wantedBy = [ "timers.target" ];
        description = "synchronize calendars and contacts (${name})";
        inherit (cfg') timerConfig;
      }
    ) cfg.jobs;
  };
}
