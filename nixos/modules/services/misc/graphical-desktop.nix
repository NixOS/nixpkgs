{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.graphical-desktop;
  xcfg = config.services.xserver;
  dmcfg = config.services.displayManager;
in
{
  options = {
    services.graphical-desktop.enable =
      lib.mkEnableOption "bits and pieces required for a graphical desktop session"
      // {
        default = xcfg.enable || dmcfg.enable;
        defaultText = lib.literalExpression "(config.services.xserver.enable || config.services.displayManager.enable)";
        internal = true;
      };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      # localectl looks into 00-keyboard.conf
      # Empty Option values are omitted: systemd-localed (since v261) considers them invalid and then ignores the whole file, breaking keymap discovery via org.freedesktop.locale1.
      etc."X11/xorg.conf.d/00-keyboard.conf".text =
        let
          options = lib.filter (opt: opt.value != "") [
            {
              name = "XkbModel";
              value = xcfg.xkb.model;
            }
            {
              name = "XkbLayout";
              value = xcfg.xkb.layout;
            }
            {
              name = "XkbOptions";
              value = xcfg.xkb.options;
            }
            {
              name = "XkbVariant";
              value = xcfg.xkb.variant;
            }
          ];
        in
        ''
          Section "InputClass"
            Identifier "Keyboard catchall"
            MatchIsKeyboard "on"
          ${lib.concatMapStrings (opt: "  Option \"${opt.name}\" \"${opt.value}\"\n") options}EndSection
        '';
      systemPackages = with pkgs; [
        nixos-icons # needed for gnome and pantheon about dialog, nixos-manual and maybe more
        xdg-utils
      ];
    };

    fonts.enableDefaultPackages = lib.mkDefault true;

    hardware.graphics.enable = lib.mkDefault true;

    programs.gnupg.agent.pinentryPackage = lib.mkOverride 1100 pkgs.pinentry-gnome3;

    services.speechd.enable = lib.mkDefault true;

    services.pipewire = {
      enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
    };

    systemd.defaultUnit = lib.mkIf (xcfg.autorun || dmcfg.enable) "graphical.target";

    xdg = {
      autostart.enable = true;
      menus.enable = true;
      mime.enable = true;
      icons.enable = true;
    };
  };
}
