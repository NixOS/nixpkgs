{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.ghostty;
in
{
  options.programs.ghostty = {
    enable = lib.mkEnableOption "ghostty terminal emulator";

    package = lib.mkPackageOption pkgs "ghostty" { };

    settings = lib.mkOption {
      type = with lib.types; attrsOf (either singleLineStr (listOf singleLineStr));
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
      systemPackages = [ (cfg.package.override { inherit (cfg) settings; }) ];
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ linsui ];
  };
}
