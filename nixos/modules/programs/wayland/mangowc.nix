{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.mangowc;
in
{
  options = {
    programs.mangowc = {
      enable = lib.mkEnableOption "mangowc, a wayland compositor based on dwl";
      package = lib.mkPackageOption pkgs "mangowc" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      cfg.package
    ]
    ++ (if (builtins.hasAttr "mmsg" cfg.package) then [ cfg.package.mmsg ] else [ ]);

    xdg.portal = {
      enable = lib.mkDefault true;

      wlr.enable = lib.mkDefault true;

      configPackages = [ cfg.package ];
    };

    security.polkit.enable = lib.mkDefault true;

    programs.xwayland.enable = lib.mkDefault true;

    services = {
      displayManager.sessionPackages = [ cfg.package ];

      graphical-desktop.enable = lib.mkDefault true;
    };
  };

  meta.maintainers = with lib.maintainers; [ hustlerone ];
}
