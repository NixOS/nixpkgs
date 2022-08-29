{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.thermald;
in
{
  ###### interface
  options = {
    services.thermald = {
      enable = mkEnableOption "thermald, the temperature management daemon";

      debug = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable debug logging.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc "the thermald manual configuration file.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.thermald;
        defaultText = literalExpression "pkgs.thermald";
        description = lib.mdDoc "Which thermald package to use.";
      };
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.dbus.packages = [ cfg.package ];

    systemd.services.thermald = {
      description = "Thermal Daemon Service";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        PrivateNetwork = true;
        ExecStart = ''
          ${cfg.package}/sbin/thermald \
            --no-daemon \
            ${optionalString cfg.debug "--loglevel=debug"} \
            ${optionalString (cfg.configFile != null) "--config-file ${cfg.configFile}"} \
            --dbus-enable \
            --adaptive
        '';
      };
    };
  };
}
