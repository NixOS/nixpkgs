{ config, pkgs, lib, ... }:
let
  cfg = config.xdg.portal.lxqt;

in
{
  meta = {
    maintainers = lib.teams.lxqt.members;
  };

  options.xdg.portal.lxqt = {
    enable = lib.mkEnableOption ''
      the desktop portal for the LXQt desktop environment.

      This will add the `lxqt.xdg-desktop-portal-lxqt`
      package (with the extra Qt styles) into the
      {option}`xdg.portal.extraPortals` option
    '';

    styles = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      example = lib.literalExpression ''[
        pkgs.libsForQt5.qtstyleplugin-kvantum
        pkgs.breeze-qt5
        pkgs.qtcurve
      ];
      '';
      description = ''
        Extra Qt styles that will be available to the
        `lxqt.xdg-desktop-portal-lxqt`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [
        (pkgs.lxqt.xdg-desktop-portal-lxqt.override { extraQtStyles = cfg.styles; })
      ];
    };

    environment.systemPackages = cfg.styles;
  };
}
