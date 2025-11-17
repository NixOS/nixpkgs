{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.programs.wayvnc;
in
{
  options.programs.wayvnc = {
    enable = lib.mkEnableOption "wayvnc, VNC server for wlroots based Wayland compositors";
    package = lib.mkPackageOption pkgs "wayvnc" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # https://github.com/any1/wayvnc/blob/master/src/pam_auth.c
    security.pam.services.wayvnc = { };
  };

  meta.maintainers = with lib.maintainers; [ qusic ];
}
