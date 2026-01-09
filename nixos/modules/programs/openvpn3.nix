{
  config,
  lib,
  pkgs,
  ...
}:

let
  json = pkgs.formats.json { };
  cfg = config.programs.openvpn3;

  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    literalExpression
    max
    options
    lists
    ;
  inherit (lib.types)
    bool
    submodule
    ints
    attrsOf
    ;
in
{
  options.programs.openvpn3 = {
    enable = mkEnableOption "the openvpn3 client";
    package = mkPackageOption pkgs "openvpn3" { };
    netcfg = mkOption {
      description = "Network configuration";
      default = { };
      type = submodule {
        options = {
          settings = mkOption {
            description = "Options stored in {file}`/etc/openvpn3/netcfg.json` configuration file";
            default = { };
            type = submodule {
              freeformType = attrsOf json.type;
              options = {
                systemd_resolved = mkOption {
                  type = bool;
                  description = "Whether to use systemd-resolved integration";
                  default = config.services.resolved.enable;
                  defaultText = literalExpression "config.services.resolved.enable";
                  example = false;
                };
              };
            };
          };
        };
      };
    };
    log-service = mkOption {
      description = "Log service configuration";
      default = { };
      type = submodule {
        options = {
          settings = mkOption {
            description = "Options stored in {file}`/etc/openvpn3/log-service.json` configuration file";
            default = { };
            type = submodule {
              freeformType = attrsOf json.type;
              options = {
                journald = mkOption {
                  description = "Use systemd-journald";
                  type = bool;
                  default = true;
                  example = false;
                };
                log_dbus_details = mkOption {
                  description = "Add D-Bus details in log file/syslog";
                  type = bool;
                  default = true;
                  example = false;
                };
                log_level = mkOption {
                  description = "How verbose should the logging be";
                  type = (ints.between 0 7) // {
                    merge = _loc: defs: lists.foldl max 0 (options.getValues defs);
                  };
                  default = 3;
                  example = 6;
                };
                timestamp = mkOption {
                  description = "Add timestamp log file";
                  type = bool;
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
