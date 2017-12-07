{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sway;
  sway = pkgs.sway;

  swayWrapped = pkgs.writeScriptBin "sway" ''
    #! ${pkgs.stdenv.shell}
    if [ "$1" != "" ]; then
      sway-setcap "$@"
      exit
    fi
    ${cfg.extraSessionCommands}
    exec ${pkgs.dbus.dbus-launch} --exit-with-session sway-setcap
  '';
  swayJoined = pkgs.symlinkJoin {
    name = "sway-wrapped";
    paths = [ swayWrapped sway ];
  };
in
{
  options.programs.sway = {
    enable = mkEnableOption "sway";

    extraSessionCommands = mkOption {
      default     = "";
      type        = types.lines;
      example = ''
        export XKB_DEFAULT_LAYOUT=us,de
        export XKB_DEFAULT_VARIANT=,nodeadkeys
        export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle,
      '';
      description = ''
        Shell commands executed just before sway is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        i3status xwayland rxvt_unicode dmenu
      ];
      example = literalExample ''
        with pkgs; [
          i3status xwayland rxvt_unicode dmenu
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
      source = "${sway}/bin/sway";
      capabilities = "cap_sys_ptrace,cap_sys_tty_config=eip";
      owner = "root";
      group = "sway";
      permissions = "u+rx,g+rx";
    };

    users.extraGroups.sway = {};

    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
  };
}
