{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.river;
in
{
  options.programs.river = {
    enable = mkEnableOption "river, a dynamic tiling Wayland compositor";

    package = mkPackageOption pkgs "river" {
      nullable = true;
      extraDescription = ''
        Set to `null` to not add any River package to your path, for example
        if you want to use the Home Manager River module to install River.
      '';
    };

    finalPackage = mkOption {
      type = with types; nullOr package;
      default =
        if cfg.package == null then null
        else cfg.package.override {
          xwaylandSupport = cfg.xwayland.enable;
        };
      defaultText = literalMD ''
        `programs.river.package` with applied configuration
      '';
      description = ''
        The River package after applying configuration.
      '';
    };

    xwayland.enable = mkEnableOption "XWayland" // { default = true; };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [ swaylock foot dmenu ];
      defaultText = literalExpression ''
        with pkgs; [ swaylock foot dmenu ];
      '';
      example = literalExpression ''
        with pkgs; [ termite rofi light ]
      '';
      description = ''
        Extra packages to be installed system wide. See
        <https://github.com/riverwm/river/wiki/Recommended-Software> and
        <https://github.com/swaywm/sway/wiki/i3-Migration-Guide#common-x11-apps-used-on-i3-with-wayland-alternatives>
        for a list of useful software.
      '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = optional (cfg.finalPackage != null) cfg.finalPackage ++ cfg.extraPackages;

      # To make a river session available if a display manager like SDDM is enabled:
      services.xserver.displayManager.sessionPackages = optional (cfg.finalPackage != null) cfg.finalPackage;
    }

    (import ./wayland-session.nix {
      inherit lib pkgs;
      xwayland = cfg.xwayland.enable;
    })
  ]);

  meta.maintainers = with maintainers; [ GaetanLepage ];
}
