{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.programs.rootston;

  rootstonWrapped = pkgs.writeScriptBin "rootston" ''
    #! ${pkgs.stdenv.shell}
    if [[ "$#" -ge 1 ]]; then
      exec ${pkgs.rootston}/bin/rootston "$@"
    else
      exec ${pkgs.rootston}/bin/rootston -C ${cfg.configFile}
    fi
  '';
in {
  options.programs.rootston = {
    enable = mkEnableOption ''
      rootston, the reference compositor for wlroots. The purpose of rootston
      is to test and demonstrate the features of wlroots (if you want a real
      Wayland compositor you should e.g. use Sway instead). You can manually
      start the compositor by running "rootston" from a terminal'';

    extraPackages = mkOption {
      type = with types; listOf package;
      default = with pkgs; [
        xwayland rxvt_unicode dmenu
      ];
      defaultText = literalExample ''
        with pkgs; [
          xwayland dmenu rxvt_unicode
        ]
      '';
      example = literalExample "[ ]";
      description = ''
        Extra packages to be installed system wide.
      '';
    };

    config = mkOption {
      type = types.str;
      default = ''
        [keyboard]
        meta-key = Logo

        # Sway/i3 like Keybindings
        # Maps key combinations with commands to execute
        # Commands include:
        # - "exit" to stop the compositor
        # - "exec" to execute a shell command
        # - "close" to close the current view
        # - "next_window" to cycle through windows
        [bindings]
        Logo+Shift+e = exit
        Logo+q = close
        Logo+m = maximize
        Alt+Tab = next_window
        Logo+Return = exec urxvt
        # Note: Dmenu will only work properly while e.g. urxvt is running.
        Logo+d = exec dmenu_run
      '';
      description = ''
        Default configuration for rootston (used when called without any
        parameters).
      '';
    };

    configFile = mkOption {
      type = types.path;
      default = "/etc/rootston.ini";
      example = literalExample "${pkgs.rootston}/etc/rootston.ini";
      description = ''
        Path to the default rootston configuration file (the "config" option
        will have no effect if you change the path).
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.etc."rootston.ini".text = cfg.config;
    environment.systemPackages = [ rootstonWrapped ] ++ cfg.extraPackages;

    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultFonts = mkDefault true;
  };

  meta.maintainers = with lib.maintainers; [ primeos ];
}
