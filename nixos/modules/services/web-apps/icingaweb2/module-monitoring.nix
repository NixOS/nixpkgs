{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.icingaweb2.modules.monitoring;

  configIni = ''
    [security]
    protected_customvars = "${lib.concatStringsSep "," cfg.generalConfig.protectedVars}"
  '';

  backendsIni =
    let
      formatBool = b: if b then "1" else "0";
    in
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: config: ''
        [${name}]
        type = "ido"
        resource = "${config.resource}"
        disabled = "${formatBool config.disabled}"
      '') cfg.backends
    );

  transportsIni = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (name: config: ''
      [${name}]
      type = "${config.type}"
      ${lib.optionalString (config.instance != null) ''instance = "${config.instance}"''}
      ${lib.optionalString (config.type == "local" || config.type == "remote") ''path = "${config.path}"''}
      ${lib.optionalString (config.type != "local") ''
        host = "${config.host}"
        ${lib.optionalString (config.port != null) ''port = "${toString config.port}"''}
        user${lib.optionalString (config.type == "api") "name"} = "${config.username}"
      ''}
      ${lib.optionalString (config.type == "api") ''password = "${config.password}"''}
      ${lib.optionalString (config.type == "remote") ''resource = "${config.resource}"''}
    '') cfg.transports
  );

in
{
  options.services.icingaweb2.modules.monitoring = with lib.types; {
    enable = lib.mkOption {
      type = bool;
      default = true;
      description = "Whether to enable the icingaweb2 monitoring module.";
    };

    generalConfig = {
      mutable = lib.mkOption {
        type = bool;
        default = false;
        description = "Make config.ini of the monitoring module mutable (e.g. via the web interface).";
      };

      protectedVars = lib.mkOption {
        type = listOf str;
        default = [
          "*pw*"
          "*pass*"
          "community"
        ];
        description = "List of string patterns for custom variables which should be excluded from user’s view.";
      };
    };

    mutableBackends = lib.mkOption {
      type = bool;
      default = false;
      description = "Make backends.ini of the monitoring module mutable (e.g. via the web interface).";
    };

    backends = lib.mkOption {
      default = {
        icinga = {
          resource = "icinga_ido";
        };
      };
      description = "Monitoring backends to define";
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                visible = false;
                default = name;
                type = str;
                description = "Name of this backend";
              };

              resource = lib.mkOption {
                type = str;
                description = "Name of the IDO resource";
              };

              disabled = lib.mkOption {
                type = bool;
                default = false;
                description = "Disable this backend";
              };
            };
          }
        )
      );
    };

    mutableTransports = lib.mkOption {
      type = bool;
      default = true;
      description = "Make commandtransports.ini of the monitoring module mutable (e.g. via the web interface).";
    };

    transports = lib.mkOption {
      default = { };
      description = "Command transports to define";
      type = attrsOf (
        submodule (
          { name, ... }:
          {
            options = {
              name = lib.mkOption {
                visible = false;
                default = name;
                type = str;
                description = "Name of this transport";
              };

              type = lib.mkOption {
                type = enum [
                  "api"
                  "local"
                  "remote"
                ];
                default = "api";
                description = "Type of  this transport";
              };

              instance = lib.mkOption {
                type = nullOr str;
                default = null;
                description = "Assign a icinga instance to this transport";
              };

              path = lib.mkOption {
                type = str;
                description = "Path to the socket for local or remote transports";
              };

              host = lib.mkOption {
                type = str;
                description = "Host for the api or remote transport";
              };

              port = lib.mkOption {
                type = nullOr str;
                default = null;
                description = "Port to connect to for the api or remote transport";
              };

              username = lib.mkOption {
                type = str;
                description = "Username for the api or remote transport";
              };

              password = lib.mkOption {
                type = str;
                description = "Password for the api transport";
              };

              resource = lib.mkOption {
                type = str;
                description = "SSH identity resource for the remote transport";
              };
            };
          }
        )
      );
    };
  };

  config = lib.mkIf (config.services.icingaweb2.enable && cfg.enable) {
    environment.etc =
      {
        "icingaweb2/enabledModules/monitoring" = {
          source = "${pkgs.icingaweb2}/modules/monitoring";
        };
      }
      // lib.optionalAttrs (!cfg.generalConfig.mutable) {
        "icingaweb2/modules/monitoring/config.ini".text = configIni;
      }
      // lib.optionalAttrs (!cfg.mutableBackends) {
        "icingaweb2/modules/monitoring/backends.ini".text = backendsIni;
      }
      // lib.optionalAttrs (!cfg.mutableTransports) {
        "icingaweb2/modules/monitoring/commandtransports.ini".text = transportsIni;
      };
  };
}
