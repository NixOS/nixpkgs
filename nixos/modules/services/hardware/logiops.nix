{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.logiops;
  configFormat = pkgs.formats.libconfig { };
  configFile = configFormat.generate "logid.cfg" cfg.config;
in
{
  options = {
    services.logiops = {
      enable = lib.mkEnableOption "LogiOps, a unofficial userspace driver for HID++ Logitech devices";

      package = lib.mkPackageOption pkgs "logiops" { };

      config = lib.mkOption {
        type = configFormat.type;
        default = { };
        example = lib.literalExpression ''
          devices = [
          {
              name = "Wireless Mouse MX Master";
              dpi = 1000;
              smartshift =
              {
                  on = true;
                  threshold = 30;
                  torque = 50;
              };
          }
          ];
        '';
        description = ''
          The standard libconfig-style config for LogiOps.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      services.logid = {
        wantedBy = [ "graphical.target" ];
        serviceConfig.ExecStart = [
          ""
          "${lib.getExe cfg.package} -c ${configFile}"
        ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ bokicoder ];
}
