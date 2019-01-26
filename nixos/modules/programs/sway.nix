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
      exec sway-setcap "$@"
    else
      exec ${pkgs.dbus}/bin/dbus-run-session sway-setcap "$@"
    fi
  '';
  swayJoined = pkgs.symlinkJoin {
    name = "sway-joined";
    paths = [ swayWrapped swayPackage ];
  };
in {
  options.programs.sway = {
    enable = mkEnableOption ''
      the tiling Wayland compositor Sway. After adding yourself to the "sway"
      group you can manually launch Sway by executing "sway" from a terminal.
      If you call "sway" with any parameters the extraSessionCommands won't be
      executed and Sway won't be launched with dbus-launch'';

    extraSessionCommands = mkOption {
      type = types.lines;
      default = "";
      example = ''
        # Define a keymap (US QWERTY is the default)
        export XKB_DEFAULT_LAYOUT=de,us
        export XKB_DEFAULT_VARIANT=nodeadkeys
        export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle,caps:escape
        # Change the Keyboard repeat delay and rate
        export WLC_REPEAT_DELAY=660
        export WLC_REPEAT_RATE=25
      '';
      description = ''
        Shell commands executed just before Sway is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        i3status xwayland rxvt_unicode dmenu
      ];
      defaultText = literalExample ''
        with pkgs; [ i3status xwayland rxvt_unicode dmenu ];
      '';
      example = literalExample ''
        with pkgs; [
          i3lock light termite
        ]
      '';
      description = ''
        Extra packages to be installed system wide.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ swayJoined ] ++ cfg.extraPackages;
    security.wrappers.sway = {
      program = "sway-setcap";
      source = "${swayPackage}/bin/sway";
      capabilities = "cap_sys_ptrace,cap_sys_tty_config=eip";
      owner = "root";
      group = "sway";
      permissions = "u+rx,g+rx";
    };

    users.groups.sway = {};
    security.pam.services.swaylock = {};

    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
    programs.dconf.enable = mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ gnidorah primeos ];
}
