{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.backlight-control-rs;
in
{
  options = {
    programs.backlight-control-rs = {
      enable = lib.mkEnableOption ''
        backlight-control-rs, and add udev rules granting access to members of the "video" group.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.backlight-control-rs ];
    services.udev.packages = [ pkgs.backlight-control-rs ];
  };

  meta.maintainers = with lib.maintainers; [ dod-101 ];
}
