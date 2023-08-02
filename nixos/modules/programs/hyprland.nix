{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.hyprland;

  finalPortalPackage = cfg.portalPackage.override {
    hyprland-share-picker = pkgs.hyprland-share-picker.override {
      hyprland = cfg.finalPackage;
    };
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

    package = mkPackageOptionMD pkgs "hyprland" { };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      default = cfg.package.override {
        enableXWayland = cfg.xwayland.enable;
        hidpiXWayland = cfg.xwayland.hidpi;
        nvidiaPatches = cfg.nvidiaPatches;
      };
      defaultText = literalExpression
        "`wayland.windowManager.hyprland.package` with applied configuration";
      description = mdDoc ''
        The Hyprland package after applying configuration.
      '';
    };

    portalPackage = mkPackageOptionMD pkgs "xdg-desktop-portal-hyprland" { };

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
    environment.systemPackages = [ cfg.finalPackage ];

    fonts.enableDefaultPackages = mkDefault true;
    hardware.opengl.enable = mkDefault true;

    programs = {
      dconf.enable = mkDefault true;
      xwayland.enable = mkDefault cfg.xwayland.enable;
    };

    security.polkit.enable = true;

    services.xserver.displayManager.sessionPackages = [ cfg.finalPackage ];

    xdg.portal = {
      enable = mkDefault true;
      extraPortals = [ finalPortalPackage ];
    };
  };
}
