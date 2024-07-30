{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.graphical-desktop;
  dmcfg = config.services.displayManager;
in
{
  options = {
    services.graphical-desktop.enable =
      lib.mkEnableOption "bits and pieces required for a graphical desktop session"
      // {
        default = config.services.xserver.enable || dmcfg.enable;
        defaultText = lib.literalExpression "(config.services.xserver.enable || config.services.displayManager.enable)";
        internal = true;
      };
  };

  config = lib.mkIf cfg.enable {
    # The default max inotify watches is 8192.
    # Nowadays most apps require a good number of inotify watches,
    # the value below is used by default on several other distros.
    boot.kernel.sysctl = {
      "fs.inotify.max_user_instances" = lib.mkDefault 524288;
      "fs.inotify.max_user_watches" = lib.mkDefault 524288;
    };

    environment = {
      # localectl looks into 00-keyboard.conf
      etc."X11/xorg.conf.d/00-keyboard.conf".text =
        let
          inherit (config.environment) xkb;
        in
        ''
          Section "InputClass"
            Identifier "Keyboard catchall"
            MatchIsKeyboard "on"
            Option "XkbModel" "${xkb.model}"
            Option "XkbLayout" "${xkb.layout}"
            Option "XkbOptions" "${xkb.options}"
            Option "XkbVariant" "${xkb.variant}"
          EndSection
        '';
      systemPackages = with pkgs; [
        nixos-icons # needed for gnome and pantheon about dialog, nixos-manual and maybe more
        xdg-utils
      ];
      xkb.enable = true;
    };

    fonts.enableDefaultPackages = lib.mkDefault true;

    hardware.graphics.enable = lib.mkDefault true;

    programs.gnupg.agent.pinentryPackage = lib.mkOverride 1100 pkgs.pinentry-gnome3;

    services.speechd.enable = lib.mkDefault true;

    systemd.defaultUnit = lib.mkIf (config.services.xserver.autorun || dmcfg.enable) "graphical.target";

    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };
  };
}
