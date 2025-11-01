{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.niri;
in
{
  options.programs.niri.xwayland-satellite = {
    enable = lib.mkEnableOption "xwayland-satellite for Niri" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs "xwayland-satellite" { };
  };

  config = lib.mkIf (cfg.enable && cfg.xwayland-satellite.enable) {
    environment.systemPackages = [ cfg.xwayland-satellite.package ];
  };

  meta.maintainers = with lib.maintainers; [
    getchoo
    sodiboo
  ];
}
