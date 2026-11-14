{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nautilus-open-any-terminal;
in
{
  options.programs.nautilus-open-any-terminal = {
    enable = lib.mkEnableOption "nautilus-open-any-terminal";

    terminal = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        The terminal emulator to add to context-entry of nautilus. Supported terminal
        emulators are listed in <https://github.com/Stunkymonkey/nautilus-open-any-terminal#supported-terminal-emulators>.
      '';
    };

    useGenericTerminalName = lib.mkEnableOption null // {
      description = ''
        Whether or not to replace the terminal name with a generic "Terminal" in the context menu.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      nautilus-python
      nautilus-open-any-terminal
    ];

    environment.sessionVariables = lib.mkIf (!config.services.desktopManager.gnome.enable) {
      NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    };

    environment.pathsToLink = [
      "/share/nautilus-python/extensions"
    ];

    programs.dconf = lib.optionalAttrs (cfg.terminal != null || cfg.useGenericTerminalName) {
      enable = true;
      profiles.user.databases = [
        {
          settings."com/github/stunkymonkey/nautilus-open-any-terminal" = (lib.optionalAttrs (cfg.terminal != null) {
              terminal = cfg.terminal;
            })
            // {
              use-generic-terminal-name = cfg.useGenericTerminalName;
            };
          lockAll = true;
        }
      ];
    };
  };
  meta = {
    maintainers = with lib.maintainers; [
      stunkymonkey
      linsui
    ];
  };
}
