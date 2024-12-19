{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.input-remapper;
in
{
  options = {
    services.input-remapper = {
      enable = lib.mkEnableOption "input-remapper, an easy to use tool to change the mapping of your input device buttons";
      package = lib.mkPackageOption pkgs "input-remapper" { };
      enableUdevRules = lib.mkEnableOption "udev rules added by input-remapper to handle hotplugged devices. Currently disabled by default due to https://github.com/sezanzeb/input-remapper/issues/140";
      serviceWantedBy = lib.mkOption {
        default = [ "graphical.target" ];
        example = [ "multi-user.target" ];
        type = lib.types.listOf lib.types.str;
        description = "Specifies the WantedBy setting for the input-remapper service.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = lib.mkIf cfg.enableUdevRules [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
    systemd.services.input-remapper.wantedBy = cfg.serviceWantedBy;
  };

  meta.maintainers = with lib.maintainers; [ LunNova ];
}
