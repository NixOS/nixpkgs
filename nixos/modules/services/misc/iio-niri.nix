{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkPackageOption
    mkOption
    types
    mkIf
    getExe
    escapeShellArgs
    mkDefault
    ;
  cfg = config.services.iio-niri;
in
{
  options.services.iio-niri = {
    enable = mkEnableOption "IIO-Niri";

    package = mkPackageOption pkgs "iio-niri" { };

    niriUnit = mkOption {
      type = types.nonEmptyStr;
      default = "niri.service";
      description = "The Niri **user** service unit to bind IIO-Niri's **user** service unit to.";
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra arguments to pass to IIO-Niri.";
    };
  };

  config = mkIf cfg.enable {
    hardware.sensor.iio.enable = mkDefault true;

    environment.systemPackages = [ cfg.package ];

    systemd.user.services.iio-niri = {
      description = "IIO-Niri";
      wantedBy = [ cfg.niriUnit ];
      bindsTo = [ cfg.niriUnit ];
      partOf = [ cfg.niriUnit ];
      after = [ cfg.niriUnit ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe cfg.package} ${escapeShellArgs cfg.extraArgs}";
        Restart = "on-failure";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ zhaithizaliel ];
}
