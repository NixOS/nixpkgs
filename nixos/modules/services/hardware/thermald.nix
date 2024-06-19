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
        description = ''
          The thermald manual configuration file.

          Leave unspecified to run with the `--adaptive` flag instead which will have thermald use your computer's DPTF adaptive tables.

          See `man thermald` for more information.
        '';
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
            ${if cfg.configFile != null then "--config-file ${cfg.configFile}" else "--adaptive"} \
            --dbus-enable
        '';
      };
    };
  };
}
