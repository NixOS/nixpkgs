{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.hyprland;

<<<<<<< HEAD
  finalPortalPackage = cfg.portalPackage.override {
    hyprland-share-picker = pkgs.hyprland-share-picker.override {
      hyprland = cfg.finalPackage;
    };
=======
  defaultHyprlandPackage = pkgs.hyprland.override {
    enableXWayland = cfg.xwayland.enable;
    hidpiXWayland = cfg.xwayland.hidpi;
    nvidiaPatches = cfg.nvidiaPatches;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
in
{
  options.programs.hyprland = {
    enable = mkEnableOption null // {
      description = mdDoc ''
        Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.

        You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.

        A configuration file will be generated in {file}`~/.config/hypr/hyprland.conf`.
        See <https://wiki.hyprland.org> for more information.
      '';
    };

<<<<<<< HEAD
    package = mkPackageOptionMD pkgs "hyprland" { };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      default = cfg.package.override {
        enableXWayland = cfg.xwayland.enable;
        enableNvidiaPatches = cfg.enableNvidiaPatches;
      };
      defaultText = literalExpression
        "`programs.hyprland.package` with applied configuration";
      description = mdDoc ''
        The Hyprland package after applying configuration.
      '';
    };

    portalPackage = mkPackageOptionMD pkgs "xdg-desktop-portal-hyprland" { };

    xwayland.enable = mkEnableOption (mdDoc "XWayland") // { default = true; };

    enableNvidiaPatches = mkEnableOption (mdDoc "patching wlroots for better Nvidia support");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];

    fonts.enableDefaultPackages = mkDefault true;
=======
    package = mkOption {
      type = types.path;
      default = defaultHyprlandPackage;
      defaultText = literalExpression ''
        pkgs.hyprland.override {
          enableXWayland = config.programs.hyprland.xwayland.enable;
          hidpiXWayland = config.programs.hyprland.xwayland.hidpi;
          nvidiaPatches = config.programs.hyprland.nvidiaPatches;
        }
      '';
      example = literalExpression "<Hyprland flake>.packages.<system>.default";
      description = mdDoc ''
        The Hyprland package to use.
        Setting this option will make {option}`programs.hyprland.xwayland` and
        {option}`programs.hyprland.nvidiaPatches` not work.
      '';
    };

    xwayland = {
      enable = mkEnableOption (mdDoc "XWayland") // { default = true; };
      hidpi = mkEnableOption null // {
        description = mdDoc ''
          Enable HiDPI XWayland, based on [XWayland MR 733](https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/733).
          See <https://wiki.hyprland.org/Nix/Options-Overrides/#xwayland-hidpi> for more info.
        '';
      };
    };

    nvidiaPatches = mkEnableOption (mdDoc "patching wlroots for better Nvidia support");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    fonts.enableDefaultFonts = mkDefault true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    hardware.opengl.enable = mkDefault true;

    programs = {
      dconf.enable = mkDefault true;
      xwayland.enable = mkDefault cfg.xwayland.enable;
    };

    security.polkit.enable = true;

<<<<<<< HEAD
    services.xserver.displayManager.sessionPackages = [ cfg.finalPackage ];

    xdg.portal = {
      enable = mkDefault true;
      extraPortals = [ finalPortalPackage ];
    };
  };

  imports = with lib; [
    (mkRemovedOptionModule
      [ "programs" "hyprland" "xwayland" "hidpi" ]
      "XWayland patches are deprecated. Refer to https://wiki.hyprland.org/Configuring/XWayland"
    )
    (mkRenamedOptionModule
      [ "programs" "hyprland" "nvidiaPatches" ]
      [ "programs" "hyprland" "enableNvidiaPatches" ]
    )
  ];
=======
    services.xserver.displayManager.sessionPackages = [ cfg.package ];

    xdg.portal = {
      enable = mkDefault true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
