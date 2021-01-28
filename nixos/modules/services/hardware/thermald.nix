{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.thermald;
in {
  ###### interface
  options = {
    services.thermald = {
      enable = mkEnableOption "thermald, the temperature management daemon";

      debug = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable debug logging.
        '';
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "the thermald manual configuration file.";
      };

      adaptive = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable adaptive mode, only working on kernel versions greater than 5.8.
          Thermald will detect this itself, safe to enable on kernel versions below 5.8.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.thermald;
        defaultText = "pkgs.thermald";
        description = "Which thermald package to use.";
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
        ExecStart = ''
          ${cfg.package}/sbin/thermald \
            --no-daemon \
            ${optionalString cfg.debug "--loglevel=debug"} \
            ${optionalString (cfg.configFile != null) "--config-file ${cfg.configFile}"} \
            ${optionalString cfg.adaptive "--adaptive"} \
            --dbus-enable
        '';
      };
    };
  };
}
