{
  config,
  lib,
  pkgs,
  ...
}:

let
  json = pkgs.formats.json { };
  cfg = config.programs.openvpn3;

in
{
  options.programs.openvpn3 = {
    enable = lib.mkEnableOption "the openvpn3 client";
    package = lib.mkPackageOption pkgs "openvpn3" { };
    netcfg = lib.mkOption {
      description = "Network configuration";
      default = { };
      type = lib.types.submodule {
        options = {
          settings = lib.mkOption {
            description = "Options stored in {file}`/etc/openvpn3/netcfg.json` configuration file";
            default = { };
            type = lib.types.submodule {
              freeformType = json.type;
              options = {
                systemd_resolved = lib.mkOption {
                  type = lib.types.bool;
                  description = "Whether to use systemd-resolved integration";
                  default = config.services.resolved.enable;
                  defaultText = lib.literalExpression "config.services.resolved.enable";
                  example = false;
                };
              };
            };
          };
        };
      };
    };
    log-service = lib.mkOption {
      description = "Log service configuration";
      default = { };
      type = lib.types.submodule {
        options = {
          settings = lib.mkOption {
            description = "Options stored in {file}`/etc/openvpn3/log-service.json` configuration file";
            default = { };
            type = lib.types.submodule {
              freeformType = json.type;
              options = {
                journald = lib.mkOption {
                  description = "Use systemd-journald";
                  type = lib.types.bool;
                  default = true;
                  example = false;
                };
                log_dbus_details = lib.mkOption {
                  description = "Add D-Bus details in log file/syslog";
                  type = lib.types.bool;
                  default = true;
                  example = false;
                };
                log_level = lib.mkOption {
                  description = "How verbose should the logging be";
                  type = (lib.types.ints.between 0 7) // {
                    merge = _loc: defs: lib.lists.foldl lib.max 0 (lib.options.getValues defs);
                  };
                  default = 3;
                  example = 6;
                };
                timestamp = lib.mkOption {
                  description = "Add timestamp log file";
                  type = lib.types.bool;
                  default = false;
                  example = true;
                };
              };
            };
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ cfg.package ];

    users.users.openvpn = {
      isSystemUser = true;
      uid = config.ids.uids.openvpn;
      group = "openvpn";
    };

    users.groups.openvpn = {
      gid = config.ids.gids.openvpn;
    };

    environment = {
      systemPackages = [ cfg.package ];
      etc = {
        "openvpn3/netcfg.json".source = json.generate "netcfg.json" cfg.netcfg.settings;
        "openvpn3/log-service.json".source = json.generate "log-service.json" cfg.log-service.settings;
      };
    };

    systemd = {
      packages = [ cfg.package ];
      tmpfiles.rules = [
        "d /etc/openvpn3/configs 0750 openvpn openvpn - -"
      ];
    };
  };

  meta.maintainers = with lib.maintainers; [
    shamilton
    progrm_jarvis
  ];
}
