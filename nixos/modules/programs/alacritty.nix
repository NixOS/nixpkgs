{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.alacritty;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.programs.alacritty = {
    enable = lib.mkEnableOption "Alacritty terminal emulator";

    package = lib.mkPackageOption pkgs "alacritty" { };

    settings = lib.mkOption {
      type = lib.types.attrsOf settingsFormat.type;
      default = { };
      example = {
        general.live_config_reload = false;
        window.decorations = "None";
        scrolling = {
          history = 6000;
          multiplier = 6;
        };
        font = {
          normal.family = "monospace";
          size = 12.0;
        };
      };
      description = ''
        Configuration for the Alacritty terminal emulator. See {manpage}`alacritty(5)` for supported settings.

        When nonempty, writes {file}`/etc/alacritty/alacritty.toml`. Alacritty uses this file only when no user configuration is found and does not automatically merge it with user configuration.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."alacritty/alacritty.toml" = lib.mkIf (cfg.settings != { }) {
        source = settingsFormat.generate "alacritty.toml" cfg.settings;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ ozozka ];
}
