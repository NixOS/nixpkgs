{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.niri.xwayland-satellite;
in
{
  options.programs.niri.xwayland-satellite = {
    enable = lib.mkEnableOption "xwayland-satellite for Niri" // {
      default = true;
    };

    package = lib.mkPackageOption pkgs "xwayland-satellite" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [
    getchoo
    sodiboo
  ];
}
