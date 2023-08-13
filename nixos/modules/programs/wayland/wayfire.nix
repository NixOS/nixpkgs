{ config, lib, pkgs, ...}:
let
  cfg = config.programs.wayfire;
in
{
  meta.maintainers = with lib.maintainers; [ rewine ];

  options.programs.wayfire = {
    enable = lib.mkEnableOption (lib.mdDoc "Wayfire, a wayland compositor based on wlroots.");

    package = lib.mkPackageOptionMD pkgs "wayfire" { };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs.wayfirePlugins; [ wcm wf-shell ];
      defaultText = lib.literalExpression "with pkgs.wayfirePlugins; [ wcm wf-shell ]";
      example = lib.literalExpression ''
        with pkgs.wayfirePlugins; [
          wcm
          wf-shell
          wayfire-plugins-extra
        ];
      '';
      description = lib.mdDoc ''
        Additional plugins to use with the wayfire window manager.
      '';
    };
  };

  config = let
    finalPackage = pkgs.wayfire-with-plugins.override {
      wayfire = cfg.package;
      plugins = cfg.plugins;
    };
  in
  lib.mkIf cfg.enable {
    environment.systemPackages = [
      finalPackage
    ];

    services.xserver.displayManager.sessionPackages = [ finalPackage ];

    xdg.portal = {
      enable = lib.mkDefault true;
      wlr.enable = lib.mkDefault true;
    };
  };
}
