{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.hyprland;

  finalPortalPackage = cfg.portalPackage.override {
    hyprland = cfg.finalPackage;
  };
in
{
  options.programs.hyprland = {
    enable = mkEnableOption null // {
      description = ''
        Whether to enable Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.

        You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.

        A configuration file will be generated in {file}`~/.config/hypr/hyprland.conf`.
        See <https://wiki.hyprland.org> for more information.
      '';
    };

    package = mkPackageOption pkgs "hyprland" { };

    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      default = cfg.package.override {
        enableXWayland = cfg.xwayland.enable;
      };
      defaultText = literalExpression
        "`programs.hyprland.package` with applied configuration";
      description = ''
        The Hyprland package after applying configuration.
      '';
    };

    portalPackage = mkPackageOption pkgs "xdg-desktop-portal-hyprland" { };

    xwayland.enable = mkEnableOption ("XWayland") // { default = true; };

    envVars.enable = mkEnableOption null // {
      default = true;
      example = false;
      description = ''
        Set environment variables for Hyprland to work properly.
        Enabled by default.
      '';
    };

    systemd.setPath.enable = mkEnableOption null // {
      default = true;
      example = false;
      description = ''
        Set environment path of systemd to include the current system's bin directory.
        This is needed in Hyprland setups, where opening links in applications do not work.
        Enabled by default.
      '';
    };
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

    services.displayManager.sessionPackages = [ cfg.finalPackage ];

    xdg.portal = {
      enable = mkDefault true;
      extraPortals = [ finalPortalPackage ];
      configPackages = mkDefault [ cfg.finalPackage ];
    };

    environment.sessionVariables = mkIf cfg.envVars.enable {
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      GDK_BACKEND = "wayland,x11";
      QT_QPA_PLATFORM = "wayland;xcb";
      _JAVA_AWT_WM_NONREPARENTING = "1"; # Fix for Java applications on tiling window managers
    };

    systemd = mkIf cfg.systemd.setPath.enable {
      user.extraConfig = ''
        DefaultEnvironment="PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin:/run/wrappers/bin"
      '';
    };
  };

  imports = with lib; [
    (mkRemovedOptionModule
      [ "programs" "hyprland" "xwayland" "hidpi" ]
      "XWayland patches are deprecated. Refer to https://wiki.hyprland.org/Configuring/XWayland"
    )
    (mkRemovedOptionModule
      [ "programs" "hyprland" "enableNvidiaPatches" ]
      "Nvidia patches are no longer needed"
    )
    (mkRemovedOptionModule
      [ "programs" "hyprland" "nvidiaPatches" ]
      "Nvidia patches are no longer needed"
    )
  ];
}
