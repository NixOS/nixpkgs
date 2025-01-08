{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.tmux;

  defaultKeyMode = "emacs";
  defaultResize = 5;
  defaultShortcut = "b";
  defaultTerminal = "screen";

  boolToStr = value: if value then "on" else "off";

  tmuxConf = ''
    set  -g default-terminal "${cfg.terminal}"
    set  -g base-index      ${toString cfg.baseIndex}
    setw -g pane-base-index ${toString cfg.baseIndex}
    set  -g history-limit   ${toString cfg.historyLimit}

    ${lib.optionalString cfg.newSession "new-session"}

    ${lib.optionalString cfg.reverseSplit ''
      bind v split-window -h
      bind s split-window -v
    ''}

    set -g status-keys ${cfg.keyMode}
    set -g mode-keys   ${cfg.keyMode}

    ${lib.optionalString (cfg.keyMode == "vi" && cfg.customPaneNavigationAndResize) ''
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r H resize-pane -L ${toString cfg.resizeAmount}
      bind -r J resize-pane -D ${toString cfg.resizeAmount}
      bind -r K resize-pane -U ${toString cfg.resizeAmount}
      bind -r L resize-pane -R ${toString cfg.resizeAmount}
    ''}

    ${lib.optionalString (cfg.shortcut != defaultShortcut) ''
      # rebind main key: C-${cfg.shortcut}
      unbind C-${defaultShortcut}
      set -g prefix C-${cfg.shortcut}
      bind ${cfg.shortcut} send-prefix
      bind C-${cfg.shortcut} last-window
    ''}

    setw -g aggressive-resize ${boolToStr cfg.aggressiveResize}
    setw -g clock-mode-style  ${if cfg.clock24 then "24" else "12"}
    set  -s escape-time       ${toString cfg.escapeTime}

    ${cfg.extraConfigBeforePlugins}

    ${lib.optionalString (cfg.plugins != [ ]) ''
      # Run plugins
      ${lib.concatMapStringsSep "\n" (x: "run-shell ${x.rtp}") cfg.plugins}

    ''}

    ${cfg.extraConfig}
  '';

in
{
  ###### interface

  options = {
    programs.tmux = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whenever to configure {command}`tmux` system-wide.";
        relatedPackages = [ "tmux" ];
      };

      aggressiveResize = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Resize the window to the size of the smallest session for which it is the current window.
        '';
      };

      baseIndex = lib.mkOption {
        default = 0;
        example = 1;
        type = lib.types.int;
        description = "Base index for windows and panes.";
      };

      clock24 = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Use 24 hour clock.";
      };

      customPaneNavigationAndResize = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Override the hjkl and HJKL bindings for pane navigation and resizing in VI mode.";
      };

      escapeTime = lib.mkOption {
        default = 500;
        example = 0;
        type = lib.types.int;
        description = "Time in milliseconds for which tmux waits after an escape is input.";
      };

      extraConfigBeforePlugins = lib.mkOption {
        default = "";
        description = ''
          Additional contents of /etc/tmux.conf, to be run before sourcing plugins.
        '';
        type = lib.types.lines;
      };

      extraConfig = lib.mkOption {
        default = "";
        description = ''
          Additional contents of /etc/tmux.conf, to be run after sourcing plugins.
        '';
        type = lib.types.lines;
      };

      historyLimit = lib.mkOption {
        default = 2000;
        example = 5000;
        type = lib.types.int;
        description = "Maximum number of lines held in window history.";
      };

      keyMode = lib.mkOption {
        default = defaultKeyMode;
        example = "vi";
        type = lib.types.enum [
          "emacs"
          "vi"
        ];
        description = "VI or Emacs style shortcuts.";
      };

      newSession = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Automatically spawn a session if trying to attach and none are running.";
      };

      reverseSplit = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Reverse the window split shortcuts.";
      };

      resizeAmount = lib.mkOption {
        default = defaultResize;
        example = 10;
        type = lib.types.int;
        description = "Number of lines/columns when resizing.";
      };

      shortcut = lib.mkOption {
        default = defaultShortcut;
        example = "a";
        type = lib.types.str;
        description = "Ctrl following by this key is used as the main shortcut.";
      };

      terminal = lib.mkOption {
        default = defaultTerminal;
        example = "screen-256color";
        type = lib.types.str;
        description = ''
          Set the $TERM variable. Use tmux-direct if italics or 24bit true color
          support is needed.
        '';
      };

      secureSocket = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Store tmux socket under /run, which is more secure than /tmp, but as a
          downside it doesn't survive user logout.
        '';
      };

      plugins = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.package;
        description = "List of plugins to install.";
        example = lib.literalExpression "[ pkgs.tmuxPlugins.nord ]";
      };

      withUtempter = lib.mkOption {
        description = ''
          Whether to enable libutempter for tmux.
          This is required so that tmux can write to /var/run/utmp (which can be queried with `who` to display currently connected user sessions).
          Note, this will add a guid wrapper for the group utmp!
        '';
        default = true;
        type = lib.types.bool;
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment = {
      etc."tmux.conf".text = tmuxConf;

      systemPackages = [ pkgs.tmux ] ++ cfg.plugins;

      variables = {
        TMUX_TMPDIR = lib.optional cfg.secureSocket ''''${XDG_RUNTIME_DIR:-"/run/user/$(id -u)"}'';
      };
    };
    security.wrappers = lib.mkIf cfg.withUtempter {
      utempter = {
        source = "${pkgs.libutempter}/lib/utempter/utempter";
        owner = "root";
        group = "utmp";
        setuid = false;
        setgid = true;
      };
    };
  };

  imports = [
    (lib.mkRenamedOptionModule
      [ "programs" "tmux" "extraTmuxConf" ]
      [ "programs" "tmux" "extraConfig" ]
    )
  ];

  meta.maintainers = with lib.maintainers; [ hxtmdev ];
}
