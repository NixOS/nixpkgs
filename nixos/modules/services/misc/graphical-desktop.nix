{
  config,
  lib,
  pkgs,
  ...
}:
let
  xcfg = config.services.xserver;
  dmcfg = config.services.displayManager;
in
{
  config = lib.mkIf (xcfg.enable || dmcfg.enable) {
    # The default max inotify watches is 8192.
    # Nowadays most apps require a good number of inotify watches,
    # the value below is used by default on several other distros.
    boot.kernel.sysctl = {
      "fs.inotify.max_user_instances" = lib.mkDefault 524288;
      "fs.inotify.max_user_watches" = lib.mkDefault 524288;
    };

    environment = {
      # localectl looks into 00-keyboard.conf
      etc."X11/xorg.conf.d/00-keyboard.conf".text = ''
        Section "InputClass"
          Identifier "Keyboard catchall"
          MatchIsKeyboard "on"
          Option "XkbModel" "${xcfg.xkb.model}"
          Option "XkbLayout" "${xcfg.xkb.layout}"
          Option "XkbOptions" "${xcfg.xkb.options}"
          Option "XkbVariant" "${xcfg.xkb.variant}"
        EndSection
      '';
      systemPackages = with pkgs; [
        nixos-icons # needed for gnome and pantheon about dialog, nixos-manual and maybe more
        xdg-utils
      ];
    };

    fonts.enableDefaultPackages = lib.mkDefault true;

    hardware.graphics.enable = lib.mkDefault true;

    programs.gnupg.agent.pinentryPackage = lib.mkOverride 1100 pkgs.pinentry-gnome3;

    systemd.defaultUnit = lib.mkIf (xcfg.autorun || dmcfg.enable) "graphical.target";

    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };
  };
}
