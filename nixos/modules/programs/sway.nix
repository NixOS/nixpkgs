{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sway;
  swayPackage = pkgs.sway;

  swayWrapped = pkgs.writeShellScriptBin "sway" ''
    set -o errexit

    if [ ! "$_SWAY_WRAPPER_ALREADY_EXECUTED" ]; then
      export _SWAY_WRAPPER_ALREADY_EXECUTED=1
      ${cfg.extraSessionCommands}
    fi

    if [ "$DBUS_SESSION_BUS_ADDRESS" ]; then
      export DBUS_SESSION_BUS_ADDRESS
      exec ${swayPackage}/bin/sway "$@"
    else
      exec ${pkgs.dbus}/bin/dbus-run-session ${swayPackage}/bin/sway "$@"
    fi
  '';
  swayJoined = pkgs.symlinkJoin {
    name = "sway-joined";
    paths = [ swayWrapped swayPackage ];
  };
in {
  options.programs.sway = {
    enable = mkEnableOption ''
      Sway, the i3-compatible tiling Wayland compositor. You can manually launch
      Sway by executing "exec sway" on a TTY. Copy /etc/sway/config to
      ~/.config/sway/config to modify the default configuration. See
      https://github.com/swaywm/sway/wiki and "man 5 sway" for more information.
      Please have a look at the "extraSessionCommands" example for running
      programs natively under Wayland'';

    extraSessionCommands = mkOption {
      type = types.lines;
      default = "";
      example = ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
      '';
      description = ''
        Shell commands executed just before Sway is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        swaylock swayidle
        xwayland rxvt_unicode dmenu
      ];
      defaultText = literalExample ''
        with pkgs; [ swaylock swayidle xwayland rxvt_unicode dmenu ];
      '';
      example = literalExample ''
        with pkgs; [
          xwayland
          i3status i3status-rust
          termite rofi light
        ]
      '';
      description = ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ swayJoined ] ++ cfg.extraPackages;
      etc = {
        "sway/config".source = mkOptionDefault "${swayPackage}/etc/sway/config";
        #"sway/security.d".source = mkOptionDefault "${swayPackage}/etc/sway/security.d/";
        #"sway/config.d".source = mkOptionDefault "${swayPackage}/etc/sway/config.d/";
      };
    };
    security.pam.services.swaylock = {};
    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ gnidorah primeos colemickens ];
}
