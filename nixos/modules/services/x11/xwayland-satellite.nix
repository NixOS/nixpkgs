{
  lib,
  pkgs,
  config,
  ...
}:

let
  cfg = config.services.xwayland-satellite;
in
{
  options.services.xwayland-satellite = {
    enable = lib.mkEnableOption "xwayland-satellite, rootless XWayland integration for any Wayland compositor";
    package = lib.mkPackageOption pkgs "xwayland-satellite" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      user.services.xwayland-satellite.wantedBy = [ "graphical-session.target" ];
    };
  };

  meta = {
    inherit (pkgs.xwayland-satellite.meta) maintainers;
  };
}
