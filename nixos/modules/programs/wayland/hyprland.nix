{ config, lib, pkgs, ... }:

let
  cfg = config.programs.hyprland;

  wayland-lib = import ./lib.nix { inherit lib; };
in
{
  options.programs.hyprland = {
    enable = lib.mkEnableOption ''
      Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.
      You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.
      A configuration file will be generated in {file}`~/.config/hypr/hyprland.conf`.
      See <https://wiki.hyprland.org> for more information'';

    package = lib.mkPackageOption pkgs "hyprland" {
      extraDescription = ''
        If the package is not overridable with `enableXWayland`, then the module option
        {option}`xwayland` will have no effect.
      '';
    } // {
      apply = p: wayland-lib.genFinalPackage p {
        enableXWayland = cfg.xwayland.enable;
      };
    };

    portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-hyprland" {
      extraDescription = ''
        If the package is not overridable with `hyprland`, then the Hyprland package
        used by the portal may differ from the one set in the module option {option}`package`.
      '';
    } // {
      apply = p: wayland-lib.genFinalPackage p {
        hyprland = cfg.package;
      };
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
      environment.systemPackages = [ cfg.package ];

      # To make a Hyprland session available if a display manager like SDDM is enabled:
      services.displayManager.sessionPackages = [ cfg.package ];

      xdg.portal = {
        enable = true;
        extraPortals = [ cfg.portalPackage ];
        configPackages = lib.mkDefault [ cfg.package ];
      };

      systemd = lib.mkIf cfg.systemd.setPath.enable {
        user.extraConfig = ''
          DefaultEnvironment="PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin:/run/wrappers/bin"
        '';
      };
    }

    (import ./wayland-session.nix {
      inherit lib pkgs;
      enableXWayland = cfg.xwayland.enable;
      enableWlrPortal = false; # Hyprland has its own portal, wlr is not needed
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

  meta.maintainers = with lib.maintainers; [ fufexan ];
}
