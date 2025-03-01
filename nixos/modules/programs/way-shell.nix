{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.way-shell;
in
{
  options.programs.way-shell = {
    enable = lib.mkEnableOption "way-shell, a GNOME-like shell for Wayland compositors";

    package = lib.mkPackageOption pkgs "way-shell" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    services.upower.enable = true;
  };
}
