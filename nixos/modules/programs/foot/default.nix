{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.foot;

  settingsFormat = pkgs.formats.ini {
    listsAsDuplicateKeys = true;
    mkKeyValue =
      with lib.generators;
      mkKeyValueDefault {
        mkValueString =
          v:
          mkValueStringDefault { } (
            if v == true then
              "yes"
            else if v == false then
              "no"
            else if v == null then
              "none"
            else
              v
          );
      } "=";
  };
in
{
  options.programs.foot = {
    enable = lib.mkEnableOption "foot terminal emulator";

    package = lib.mkPackageOption pkgs "foot" { };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Configuration for foot terminal emulator. Further information can be found in {command}`man 5 foot.ini`.

        Global configuration has to be written under the [main] section.
      '';
      example = {
        main.font = "FreeMono:size=12";
        scrollback.lines = 100000;
      };
    };

    theme = lib.mkOption {
      type = with lib.types; nullOr str;
      default = null;
      description = ''
        Theme name. Check <https://codeberg.org/dnkl/foot/src/branch/master/themes> for available themes.
      '';
      example = "aeroroot";
    };

    enableBashIntegration = lib.mkEnableOption "foot bash integration" // {
      default = true;
    };

    enableFishIntegration = lib.mkEnableOption "foot fish integration" // {
      default = true;
    };

    enableZshIntegration = lib.mkEnableOption "foot zsh integration" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      etc."xdg/foot/foot.ini".source = settingsFormat.generate "foot.ini" cfg.settings;
    };
    programs = {
      foot.settings.main.include = lib.optionals (cfg.theme != null) [
        "${pkgs.foot.themes}/share/foot/themes/${cfg.theme}"
      ];
      # https://codeberg.org/dnkl/foot/wiki#user-content-shell-integration
      bash.interactiveShellInit = lib.mkIf cfg.enableBashIntegration ". ${./bashrc} # enable shell integration for foot terminal";
      fish.interactiveShellInit = lib.mkIf cfg.enableFishIntegration "source ${./config.fish} # enable shell integration for foot terminal";
      zsh.interactiveShellInit = lib.mkIf cfg.enableZshIntegration ". ${./zshrc} # enable shell integration for foot terminal";
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ linsui ];
  };
}
