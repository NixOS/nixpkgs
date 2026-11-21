{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.thermald;
in
{
  ###### interface
  options = {
    services.thermald = {
      enable = lib.mkEnableOption "thermald, the temperature management daemon";

      debug = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable debug logging.
        '';
      };

      ignoreCpuidCheck = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to ignore the cpuid check to allow running on unsupported platforms";
      };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          The thermald manual configuration file.

          Leave unspecified to run with the `--adaptive` flag instead which will have thermald use your computer's DPTF adaptive tables.

          See `man thermald` for more information.
        '';
      };

      package = lib.mkPackageOption pkgs "thermald" { };
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];

    systemd.services.thermald = {
      documentation = [ "man:thermald(8)" ];
      wantedBy = [ "multi-user.target" ];
      aliases = [ "dbus-org.freedesktop.thermald.service" ];
      startLimitBurst = 25;
      startLimitIntervalSec = 150;
      serviceConfig = {
        PrivateNetwork = true;
        RestartSec = "5s";
        ExecStart = [
          ""
          (lib.concatStringsSep " " (
            [
              "${cfg.package}/sbin/thermald"
              "--systemd"
              "--dbus-enable"
              (if cfg.configFile != null then "--config-file ${cfg.configFile}" else "--adaptive")
            ]
            ++ lib.optional cfg.debug "--loglevel=debug"
            ++ lib.optional cfg.ignoreCpuidCheck "--ignore-cpuid-check"
          ))
        ];
      };
    };
  };
}
