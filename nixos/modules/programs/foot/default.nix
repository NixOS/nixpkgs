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
      type = lib.types.submodule {
        freeformType = settingsFormat.type;

        options = {
          main = lib.mkOption {
            type = settingsFormat.type.nestedTypes.elemType;
            default = { };
            description = ''
              Main configuration section (global section). All options that
              could occur outside any section in {manpage}`foot.ini(5)` need to
              be placed in this section.
            '';
          };
        };
      };

      default = { };

      description = ''
        Configuration for foot terminal emulator. Further information can be
        found in {manpage}`foot.ini(5)`.
      '';

      example = {
        main.font = "FreeMono:size=12";
        scrollback.lines = 100000;
      };
    };

    theme = lib.mkOption {
      type =
        with lib.types;
        nullOr (oneOf [
          path
          str
        ]);
      default = null;
      description = ''
        Theme to use for foot. This can be either a theme config file to include
        (given as a path) or the name of one of the themes bundled with foot
        (given as a plain string).
        See <https://codeberg.org/dnkl/foot/src/branch/master/themes> for a
        full list of available themes.
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
      foot.settings.main.include = lib.mkIf (cfg.theme != null) (
        if lib.hasPrefix "/" (toString cfg.theme) then
          "${cfg.theme}"
        else
          "${cfg.package.themes}/share/foot/themes/${cfg.theme}"
      );
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
