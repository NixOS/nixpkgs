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
        description = ''
          Whether to enable debug logging.
        '';
      };

     ignoreCpuidCheck = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to ignore the cpuid check to allow running on unsupported platforms";
      };

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "the thermald manual configuration file.";
      };

      package = mkPackageOption pkgs "thermald" { };
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
            ${optionalString cfg.ignoreCpuidCheck "--ignore-cpuid-check"} \
            ${optionalString (cfg.configFile != null) "--config-file ${cfg.configFile}"} \
            ${optionalString (cfg.configFile == null) "--adaptive"} \
            --dbus-enable
        '';
      };
    };
  };
}
