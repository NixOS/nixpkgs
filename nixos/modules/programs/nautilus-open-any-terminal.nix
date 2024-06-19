{ config, lib, pkgs, ... }:

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
        emulators are listed in https://github.com/Stunkymonkey/nautilus-open-any-terminal#supported-terminal-emulators.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnome.nautilus-python
      nautilus-open-any-terminal
    ];
    programs.dconf = lib.optionalAttrs (cfg.terminal != null) {
      enable = true;
      profiles.user.databases = [{
        settings."com/github/stunkymonkey/nautilus-open-any-terminal".terminal = cfg.terminal;
        lockAll = true;
      }];
    };
  };
  meta = {
    maintainers = with lib.maintainers; [ stunkymonkey linsui ];
  };
}
