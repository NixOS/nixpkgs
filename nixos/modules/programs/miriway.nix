{ config, pkgs, lib, ... }:

let
  cfg = config.programs.miriway;
in {
  options.programs.miriway = {
    enable = lib.mkEnableOption ''
      Miriway, a Mir based Wayland compositor. You can manually launch Miriway by
      executing "exec miriway" on a TTY, or launch it from a display manager. Copy
      /etc/xdg/xdg-miriway/miriway-shell.config to ~/.config/miriway-shell.config
      to modify the system-wide configuration on a per-user basis. See <https://github.com/Miriway/Miriway>,
      and "miriway --help" for more information'';

    config = lib.mkOption {
      type = lib.types.lines;
      default = ''
        x11-window-title=Miriway (Mir-on-X)
        idle-timeout=600
        ctrl-alt=t:miriway-terminal # Default "terminal emulator finder"

        shell-component=dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY

        meta=Left:@dock-left
        meta=Right:@dock-right
        meta=Space:@toggle-maximized
        meta=Home:@workspace-begin
        meta=End:@workspace-end
        meta=Page_Up:@workspace-up
        meta=Page_Down:@workspace-down
        ctrl-alt=BackSpace:@exit
      '';
      example = ''
        idle-timeout=300
        ctrl-alt=t:weston-terminal
        add-wayland-extensions=all

        shell-components=dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY

        shell-component=waybar
        shell-component=wbg Pictures/wallpaper

        shell-meta=a:synapse

        meta=Left:@dock-left
        meta=Right:@dock-right
        meta=Space:@toggle-maximized
        meta=Home:@workspace-begin
        meta=End:@workspace-end
        meta=Page_Up:@workspace-up
        meta=Page_Down:@workspace-down
        ctrl-alt=BackSpace:@exit
      '';
      description = ''
        Miriway's config. This will be installed system-wide.
        The default will install the miriway package's barebones example config.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.miriway ];
      etc = {
        "xdg/xdg-miriway/miriway-shell.config".text = cfg.config;
      };
    };

    hardware.opengl.enable = lib.mkDefault true;
    fonts.enableDefaultPackages = lib.mkDefault true;
    programs.dconf.enable = lib.mkDefault true;
    programs.xwayland.enable = lib.mkDefault true;

    # To make the Miriway session available if a display manager like SDDM is enabled:
    services.displayManager.sessionPackages = [ pkgs.miriway ];
  };

  meta.maintainers = with lib.maintainers; [ OPNA2608 ];
}
