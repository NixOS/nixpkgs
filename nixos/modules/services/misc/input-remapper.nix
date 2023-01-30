{ pkgs, lib, config, ... }:

with lib;

let cfg = config.services.input-remapper; in
{
  options = {
    services.input-remapper = {
      enable = mkEnableOption (lib.mdDoc "input-remapper, an easy to use tool to change the mapping of your input device buttons.");
      package = mkPackageOptionMD pkgs "input-remapper" { };
      enableUdevRules = mkEnableOption (lib.mdDoc "udev rules added by input-remapper to handle hotplugged devices. Currently disabled by default due to https://github.com/sezanzeb/input-remapper/issues/140");
      serviceWantedBy = mkOption {
        default = [ "graphical.target" ];
        example = [ "multi-user.target" ];
        type = types.listOf types.str;
        description = lib.mdDoc "Specifies the WantedBy setting for the input-remapper service.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = mkIf cfg.enableUdevRules [ cfg.package ];
    services.dbus.packages = [ cfg.package ];
    systemd.packages = [ cfg.package ];
    environment.systemPackages = [ cfg.package ];
    systemd.services.input-remapper.wantedBy = cfg.serviceWantedBy;
  };

  meta.maintainers = with lib.maintainers; [ LunNova ];
}
