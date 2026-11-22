{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.miriway;
in
{
  options.programs.miriway = {
    enable = lib.mkEnableOption ''
      Miriway, a Mir based Wayland compositor. You can manually launch Miriway by
      executing "exec miriway" on a TTY, or launch it from a display manager. Copy
      /etc/xdg/xdg-miriway/miriway-shell.config to ~/.config/miriway-shell.config
      and /etc/xdg/xdg-miriway/miriway-shell.settings to ~/.config/miriway-shell.settings
      to modify the system-wide configuration on a per-user basis. See <https://github.com/Miriway/Miriway>,
      and "miriway --help" for more information'';

    config = lib.mkOption {
      description = ''
        Contents of system-wide miriway-shell.config. See Miriway's configuration documentation for details.
      '';
      type = lib.types.lines;
      default = ''
        x11-window-title=Miriway (Mir-on-X)
        idle-timeout=600
      '';
      example = ''
        idle-timeout=300
        add-wayland-extensions=all

        shell-component=waybar
        shell-component=wbg Pictures/wallpaper
      '';
    };

    settings = lib.mkOption {
      description = ''
        Contents of system-wide miriway-shell.settings. See Miriway's configuration documentation for details.
      '';
      type = lib.types.lines;
      default = ''
        command_ctrl_alt=t:miriway-terminal # Default "terminal emulator finder"

        command_meta=Left:@dock-left
        command_meta=Right:@dock-right
        command_meta=Space:@toggle-maximized
        command_meta=Home:@workspace-begin
        command_meta=End:@workspace-end
        command_meta=Page_Up:@workspace-up
        command_meta=Page_Down:@workspace-down
        command_ctrl_alt=BackSpace:@exit
      '';
      example = ''
        command_ctrl_alt=t:weston-terminal
        command_shell_meta=a:synapse

        command_meta=Left:@dock-left
        command_meta=Right:@dock-right
        command_meta=Space:@toggle-maximized
        command_meta=Home:@workspace-begin
        command_meta=End:@workspace-end
        command_meta=Page_Up:@workspace-up
        command_meta=Page_Down:@workspace-down
        command_ctrl_alt=BackSpace:@exit
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    warnings =
      let
        optionsNoLongerInConfig = [
          "ctrl-alt"
          "meta"
          "shell-ctrl-alt"
          "shell-meta"
          "shell-plain"

          "command_ctrl_alt"
          "command_meta"
          "command_shell_ctrl_alt"
          "command_shell_meta"
          "command_plain"
        ];
      in
      # Added 2026-07-17
      lib.optional
        (builtins.foldl' (
          acc: option: acc || (lib.strings.hasInfix "${option}=" cfg.config)
        ) false optionsNoLongerInConfig)
        ''
          Since Miriway 26.06, configuration options got partially renamed and split across different files.
          A new option `programs.miriway.settings` got introduced for options that belong into miriway-shell.settings
          instead of miriway-shell.config.

          You appear to have one of the following options in `programs.miriway.config` that should now go into
          `programs.miriway.settings`, and may need to be renamed:
          ${lib.strings.concatStringsSep ", " optionsNoLongerInConfig}
        '';

    environment = {
      systemPackages = with pkgs; [
        miriway
        vanilla-dmz
      ];
      etc = {
        "xdg/xdg-miriway/miriway-shell.config".text = cfg.config;
        "xdg/xdg-miriway/miriway-shell.settings".text = cfg.settings;
      };
    };

    hardware.graphics.enable = lib.mkDefault true;
    fonts.enableDefaultPackages = lib.mkDefault true;
    programs.dconf.enable = lib.mkDefault true;
    programs.xwayland.enable = lib.mkDefault true;

    # To make the Miriway session available if a display manager like SDDM is enabled:
    services.displayManager.sessionPackages = [ pkgs.miriway ];

    xdg.icons.enable = true;
    xdg.icons.fallbackCursorThemes = lib.mkDefault [
      # Miriway looks for "default" theme, fails to start if not present
      # Mir normally looks for DMZ-White theme if none specified, so make that present as the default
      "DMZ-White"
    ];
  };

  meta.maintainers = with lib.maintainers; [ OPNA2608 ];
}
