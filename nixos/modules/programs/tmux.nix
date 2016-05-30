{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption mkEnableOption mkIf mkMerge types;

  cfg = config.programs.tmux;

  defaultKeyMode  = "emacs";
  defaultResize   = 5;
  defaultShortcut = "b";
  defaultTerminal = "screen";

  boolToStr = value: if value then "on" else "off";

  tmuxConf = ''
    set  -g default-terminal "${cfg.terminal}"
    set  -g base-index      ${toString cfg.baseIndex}
    setw -g pane-base-index ${toString cfg.baseIndex}

    ${if cfg.newSession then "new-session" else ""}

    ${if cfg.reverseSplit then ''
    bind v split-window -h
    bind s split-window -v
    '' else ""}

    set -g status-keys ${cfg.keyMode}
    set -g mode-keys   ${cfg.keyMode}

    ${if cfg.keyMode == "vi" then ''
    bind h select-pane -L
    bind j select-pane -D
    bind k select-pane -U
    bind l select-pane -R

    bind -r H resize-pane -L ${toString cfg.resizeAmount}
    bind -r J resize-pane -D ${toString cfg.resizeAmount}
    bind -r K resize-pane -U ${toString cfg.resizeAmount}
    bind -r L resize-pane -R ${toString cfg.resizeAmount}
    '' else ""}

    ${if (cfg.shortcut != defaultShortcut) then ''
    # rebind main key: C-${cfg.shortcut}
    unbind C-${defaultShortcut}
    set -g prefix C-${cfg.shortcut}
    bind ${cfg.shortcut} send-prefix
    bind C-${cfg.shortcut} last-window
    '' else ""}

    setw -g aggressive-resize ${boolToStr cfg.aggressiveResize}
    setw -g clock-mode-style  ${if cfg.clock24 then "24" else "12"}
    set  -s escape-time       ${toString cfg.escapeTime}
    set  -g history-limit     ${toString cfg.historyLimit}

    ${cfg.extraTmuxConf}
  '';

in {
  ###### interface

  options = {
    programs.tmux = {

      enable = mkEnableOption "<command>tmux</command> - a <command>screen</command> replacement.";

      aggressiveResize = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = ''
          Resize the window to the size of the smallest session for which it is the current window.
        '';
      };

      baseIndex = mkOption {
        default = 0;
        example = 1;
        type = types.int;
        description = "Base index for windows and panes.";
      };

      clock24 = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = "Use 24 hour clock.";
      };

      escapeTime = mkOption {
        default = 500;
        example = 0;
        type = types.int;
        description = "Time in milliseconds for which tmux waits after an escape is input.";
      };

      extraTmuxConf = mkOption {
        default = "";
        description = ''
          Additional contents of /etc/tmux.conf
        '';
        type = types.lines;
      };

      historyLimit = mkOption {
        default = 2000;
        example = 5000;
        type = types.int;
        description = "Maximum number of lines held in window history.";
      };

      keyMode = mkOption {
        default = defaultKeyMode;
        example = "vi";
        type = types.enum [ "emacs" "vi" ];
        description = "VI or Emacs style shortcuts.";
      };

      newSession = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = "Automatically spawn a session if trying to attach and none are running.";
      };

      reverseSplit = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = "Reverse the window split shortcuts.";
      };

      resizeAmount = mkOption {
        default = defaultResize;
        example = 10;
        type = types.int;
        description = "Number of lines/columns when resizing.";
      };

      shortcut = mkOption {
        default = defaultShortcut;
        example = "a";
        type = types.str;
        description = "Ctrl following by this key is used as the main shortcut.";
      };

      terminal = mkOption {
        default = defaultTerminal;
        example = "screen-256color";
        type = types.str;
        description = "Set the $TERM variable.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment = {
      etc."tmux.conf".text = tmuxConf;

      systemPackages = [ pkgs.tmux ];

      variables = {
        TMUX_TMPDIR = ''''${XDG_RUNTIME_DIR:-"/run/user/\$(id -u)"}'';
      };
    };
  };
}
