{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.sway;
  sway = pkgs.sway;

  swayWrapped = pkgs.writeScriptBin "sway" ''
    #! ${pkgs.stdenv.shell}
    ${cfg.extraSessionCommands}
    PATH="${sway}/bin:$PATH"
    exec ${pkgs.dbus.dbus-launch} --exit-with-session "${sway}/bin/sway"
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
        export XKB_DEFAULT_LAYOUT=us,ru
        export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle,
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      '';
      description = ''
        Shell commands executed just before sway is started.
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [ ];
      example = literalExample ''
        with pkgs; [
          i3status
          xwayland j4-dmenu-desktop dunst
          qt5.qtwayland
          imagemagick
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
      source = "${swayJoined}/bin/sway";
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
