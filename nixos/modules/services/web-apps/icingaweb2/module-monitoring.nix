{ config, lib, pkgs, ... }: with lib; let
  cfg = config.services.icingaweb2.modules.monitoring;

  configIni = ''
    [security]
    protected_customvars = "${concatStringsSep "," cfg.generalConfig.protectedVars}"
  '';

  backendsIni = let
    formatBool = b: if b then "1" else "0";
  in concatStringsSep "\n" (mapAttrsToList (name: config: ''
    [${name}]
    type = "ido"
    resource = "${config.resource}"
    disabled = "${formatBool config.disabled}"
  '') cfg.backends);

  transportsIni = concatStringsSep "\n" (mapAttrsToList (name: config: ''
    [${name}]
    type = "${config.type}"
    ${optionalString (config.instance != null) ''instance = "${config.instance}"''}
    ${optionalString (config.type == "local" || config.type == "remote") ''path = "${config.path}"''}
    ${optionalString (config.type != "local") ''
      host = "${config.host}"
      ${optionalString (config.port != null) ''port = "${toString config.port}"''}
      user${optionalString (config.type == "api") "name"} = "${config.username}"
    ''}
    ${optionalString (config.type == "api") ''password = "${config.password}"''}
    ${optionalString (config.type == "remote") ''resource = "${config.resource}"''}
  '') cfg.transports);

in {
  options.services.icingaweb2.modules.monitoring = with types; {
    enable = mkOption {
      type = bool;
      default = true;
      description = lib.mdDoc "Whether to enable the icingaweb2 monitoring module.";
    };

    generalConfig = {
      mutable = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc "Make config.ini of the monitoring module mutable (e.g. via the web interface).";
      };

      protectedVars = mkOption {
        type = listOf str;
        default = [ "*pw*" "*pass*" "community" ];
        description = lib.mdDoc "List of string patterns for custom variables which should be excluded from user’s view.";
      };
    };

    mutableBackends = mkOption {
      type = bool;
      default = false;
      description = lib.mdDoc "Make backends.ini of the monitoring module mutable (e.g. via the web interface).";
    };

    backends = mkOption {
      default = { icinga = { resource = "icinga_ido"; }; };
      description = lib.mdDoc "Monitoring backends to define";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this backend";
          };

          resource = mkOption {
            type = str;
            description = lib.mdDoc "Name of the IDO resource";
          };

          disabled = mkOption {
            type = bool;
            default = false;
            description = lib.mdDoc "Disable this backend";
          };
        };
      }));
    };

    mutableTransports = mkOption {
      type = bool;
      default = true;
      description = lib.mdDoc "Make commandtransports.ini of the monitoring module mutable (e.g. via the web interface).";
    };

    transports = mkOption {
      default = {};
      description = lib.mdDoc "Command transports to define";
      type = attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            visible = false;
            default = name;
            type = str;
            description = "Name of this transport";
          };

          type = mkOption {
            type = enum [ "api" "local" "remote" ];
            default = "api";
            description = lib.mdDoc "Type of  this transport";
          };

          instance = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Assign a icinga instance to this transport";
          };

          path = mkOption {
            type = str;
            description = lib.mdDoc "Path to the socket for local or remote transports";
          };

          host = mkOption {
            type = str;
            description = lib.mdDoc "Host for the api or remote transport";
          };

          port = mkOption {
            type = nullOr str;
            default = null;
            description = lib.mdDoc "Port to connect to for the api or remote transport";
          };

          username = mkOption {
            type = str;
            description = lib.mdDoc "Username for the api or remote transport";
          };

          password = mkOption {
            type = str;
            description = lib.mdDoc "Password for the api transport";
          };

          resource = mkOption {
            type = str;
            description = lib.mdDoc "SSH identity resource for the remote transport";
          };
        };
      }));
    };
  };

  config = mkIf (config.services.icingaweb2.enable && cfg.enable) {
    environment.etc = { "icingaweb2/enabledModules/monitoring" = { source = "${pkgs.icingaweb2}/modules/monitoring"; }; }
      // optionalAttrs (!cfg.generalConfig.mutable) { "icingaweb2/modules/monitoring/config.ini".text = configIni; }
      // optionalAttrs (!cfg.mutableBackends) { "icingaweb2/modules/monitoring/backends.ini".text = backendsIni; }
      // optionalAttrs (!cfg.mutableTransports) { "icingaweb2/modules/monitoring/commandtransports.ini".text = transportsIni; };
  };
}
