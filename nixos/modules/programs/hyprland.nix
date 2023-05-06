{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.programs.hyprland;

  defaultHyprlandPackage = pkgs.hyprland.override {
    enableXWayland = cfg.xwayland.enable;
    hidpiXWayland = cfg.xwayland.hidpi;
    nvidiaPatches = cfg.nvidiaPatches;
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
    hardware.opengl.enable = mkDefault true;

    programs = {
      dconf.enable = mkDefault true;
      xwayland.enable = mkDefault cfg.xwayland.enable;
    };

    security.polkit.enable = true;

    services.xserver.displayManager.sessionPackages = [ cfg.package ];

    xdg.portal = {
      enable = mkDefault true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };
}
