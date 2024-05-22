{ config, lib, pkgs, ... }:

let
  cfg = config.programs.hyprland;
in
{
  options.programs.hyprland = {
    enable = lib.mkEnableOption ''
      Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
      You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.
      A configuration file will be generated in {file}`~/.config/hypr/hyprland.conf`.
      See <https://wiki.hyprland.org> for more information'';

    package = lib.mkPackageOption pkgs "hyprland" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = cfg.package.override {
        enableXWayland = cfg.xwayland.enable;
      };
      defaultText = lib.literalMD ''
        `programs.hyprland.package` with applied configuration
      '';
      description = ''
        The Hyprland package after applying configuration.
      '';
    };

    portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-hyprland" { };

    finalPortalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = cfg.portalPackage.override {
        hyprland = cfg.finalPackage;
      };
      defaultText = lib.literalMD ''
        `programs.hyprland.portalPackage` with applied configuration
      '';
      description = ''
        The Hyprland Portal package after applying configuration.
      '';
    };

    xwayland.enable = lib.mkEnableOption "XWayland" // { default = true; };

    systemd.setPath.enable = lib.mkEnableOption null // {
      default = true;
      example = false;
      description = ''
        Set environment path of systemd to include the current system's bin directory.
        This is needed in Hyprland setups, where opening links in applications do not work.
        Enabled by default.
      '';
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      environment.systemPackages = [ cfg.finalPackage ];

      # To make a Hyprland session available if a display manager like SDDM is enabled:
      services.displayManager.sessionPackages = [ cfg.finalPackage ];

      xdg.portal = {
        extraPortals = [ cfg.finalPortalPackage ];
        configPackages = lib.mkDefault [ cfg.finalPackage ];
      };

      systemd = lib.mkIf cfg.systemd.setPath.enable {
        user.extraConfig = ''
          DefaultEnvironment="PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin:/run/wrappers/bin"
        '';
      };
    }

    (import ./wayland-session.nix {
      inherit lib pkgs;
      xwayland = cfg.xwayland.enable;
    })
  ]);

  imports = [
    (lib.mkRemovedOptionModule
      [ "programs" "hyprland" "xwayland" "hidpi" ]
      "XWayland patches are deprecated. Refer to https://wiki.hyprland.org/Configuring/XWayland"
    )
    (lib.mkRemovedOptionModule
      [ "programs" "hyprland" "enableNvidiaPatches" ]
      "Nvidia patches are no longer needed"
    )
    (lib.mkRemovedOptionModule
      [ "programs" "hyprland" "nvidiaPatches" ]
      "Nvidia patches are no longer needed"
    )
  ];
}
