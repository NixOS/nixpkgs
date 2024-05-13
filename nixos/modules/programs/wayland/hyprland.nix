{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.programs.hyprland;

  finalPortalPackage = cfg.portalPackage.override {
    hyprland = cfg.finalPackage;
  };
in
{
  options.programs.hyprland = {
    enable = lib.mkEnableOption null // {
      description = ''
        Whether to enable Hyprland, the dynamic tiling Wayland compositor that doesn't sacrifice on its looks.

        You can manually launch Hyprland by executing {command}`Hyprland` on a TTY.

        A configuration file will be generated in {file}`~/.config/hypr/hyprland.conf`.
        See <https://wiki.hyprland.org> for more information.
      '';
    };

    package = lib.mkPackageOption pkgs "hyprland" { };

    finalPackage = lib.mkOption {
      type = lib.types.package;
      readOnly = true;
      default = cfg.package.override {
        enableXWayland = cfg.xwayland.enable;
      };
      defaultText = lib.literalExpression
        "`programs.hyprland.package` with applied configuration";
      description = ''
        The Hyprland package after applying configuration.
      '';
    };

    portalPackage = lib.mkPackageOption pkgs "xdg-desktop-portal-hyprland" { };

    xwayland.enable = lib.mkEnableOption ("XWayland") // { default = true; };

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

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.finalPackage ];

    fonts.enableDefaultPackages = lib.mkDefault true;
    hardware.opengl.enable = lib.mkDefault true;

    programs = {
      dconf.enable = lib.mkDefault true;
      xwayland.enable = lib.mkDefault cfg.xwayland.enable;
    };

    security.polkit.enable = true;

    services.displayManager.sessionPackages = [ cfg.finalPackage ];

    xdg.portal = {
      enable = lib.mkDefault true;
      extraPortals = [ finalPortalPackage ];
      configPackages = lib.mkDefault [ cfg.finalPackage ];
    };

    systemd = lib.mkIf cfg.systemd.setPath.enable {
      user.extraConfig = ''
        DefaultEnvironment="PATH=$PATH:/run/current-system/sw/bin:/etc/profiles/per-user/%u/bin:/run/wrappers/bin"
      '';
    };
  };

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
