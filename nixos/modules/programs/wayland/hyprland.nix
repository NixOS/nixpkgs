{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.hyprland;
in
{
  options.programs.hyprland = {
    enable = mkEnableOption ''
      Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
      You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.
      A configuration file will be generated in {file}`~/.config/hypr/hyprland.conf`.
      See <https://wiki.hyprland.org> for more information'';

    package = mkPackageOption pkgs "hyprland" { };

    finalPackage = mkOption {
      type = types.package;
      default = cfg.package.override {
        enableXWayland = cfg.xwayland.enable;
        enableNvidiaPatches = cfg.enableNvidiaPatches;
      };
      defaultText = literalMD ''
        `programs.hyprland.package` with applied configuration
      '';
      description = ''
        The Hyprland package after applying configuration.
      '';
    };

    portalPackage = mkPackageOption pkgs "xdg-desktop-portal-hyprland" { };

    finalPortalPackage = mkOption {
      type = types.package;
      default = cfg.portalPackage.override {
        hyprland = cfg.finalPackage;
      };
      defaultText = literalMD ''
        `programs.hyprland.portalPackage` with applied configuration
      '';
      description = ''
        The Hyprland Portal package after applying configuration.
      '';
    };

    xwayland.enable = mkEnableOption "XWayland" // { default = true; };

    enableNvidiaPatches = mkEnableOption "patching wlroots for better Nvidia support";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.systemPackages = [ cfg.finalPackage ];

      # To make a Hyprland session available if a display manager like SDDM is enabled:
      services.xserver.displayManager.sessionPackages = [ cfg.finalPackage ];

      xdg.portal = {
        extraPortals = [ cfg.finalPortalPackage ];
        configPackages = mkDefault [ cfg.finalPackage ];
      };
    }

    (import ./wayland-session.nix {
      inherit lib pkgs;
      xwayland = cfg.xwayland.enable;
    })
  ]);

  imports = [
    (mkRemovedOptionModule
      [ "programs" "hyprland" "xwayland" "hidpi" ]
      "XWayland patches are deprecated. Refer to https://wiki.hyprland.org/Configuring/XWayland"
    )
    (mkRenamedOptionModule
      [ "programs" "hyprland" "nvidiaPatches" ]
      [ "programs" "hyprland" "enableNvidiaPatches" ]
    )
  ];
}
