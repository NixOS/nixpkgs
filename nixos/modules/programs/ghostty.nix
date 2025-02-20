{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.ghostty;

  configurationFileFormat = pkgs.formats.keyValue {
    listsAsDuplicateKeys = true;
    mkKeyValue = lib.generators.mkKeyValueDefault { } " = ";
  };
in

{
  options.programs.ghostty = {
    enable = lib.mkEnableOption "ghostty terminal emulator";

    package = lib.mkPackageOption pkgs "ghostty" { } // {
      apply =
        pkg:
        pkg.override (old: {
          settings = old.settings or { } // cfg.settings;
        });
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = configurationFileFormat.type;
      };
      default = { };
      description = ''
        Configuration for ghostty terminal emulator. See <https://ghostty.org/docs/config/reference> for details.
      '';
      example = {
        font-size = "12";
        keybind = [
          "performable:ctrl+c=copy_to_clipboard"
          "ctrl+v=paste_from_clipboard"
        ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
    };
  };

  meta = {
    inherit (pkgs.ghostty.meta) maintainers;
  };
}
