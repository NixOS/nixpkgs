{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (builtins) isList elem;
  inherit (lib)
    getExe
    literalExpression
    maintainers
    mapAttrs'
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    nameValuePair
    optionalString
    types
    isBool
    boolToString
    ;
  inherit (types) listOf package;

  cfg = config.programs.bat;

  settingsFormat = pkgs.formats.keyValue { listsAsDuplicateKeys = true; };
  inherit (settingsFormat) generate type;

  recursiveToString =
    value:
    if isList value then
      map recursiveToString value
    else if isBool value then
      boolToString value
    else
      toString value;

  initScript =
    {
      program,
      shell,
      flags ? [ ],
    }:
    if (shell != "fish") then
      ''
        eval "$(${getExe program} ${toString flags})"
      ''
    else
      ''
        ${getExe program} ${toString flags} | source
      '';

  shellInit =
    shell:
    optionalString (elem pkgs.bat-extras.batpipe cfg.extraPackages) (initScript {
      program = pkgs.bat-extras.batpipe;
      inherit shell;
    })
    + optionalString (elem pkgs.bat-extras.batman cfg.extraPackages) (initScript {
      program = pkgs.bat-extras.batman;
      inherit shell;
      flags = [ "--export-env" ];
    });
in
{
  options.programs.bat = {
    enable = mkEnableOption "`bat`, a {manpage}`cat(1)` clone with wings";

    package = mkPackageOption pkgs "bat" { };

    extraPackages = mkOption {
      default = [ ];
      example = literalExpression ''
        with pkgs.bat-extras; [
          batdiff
          batman
          prettybat
        ];
      '';
      description = ''
        Extra `bat` scripts to be added to the system configuration.
      '';
      type = listOf package;
    };

    settings = mkOption {
      default = { };
      example = {
        theme = "TwoDark";
        italic-text = "always";
        paging = "never";
        pager = "less --RAW-CONTROL-CHARS --quit-if-one-screen --mouse";
        map-syntax = [
          "*.ino:C++"
          ".ignore:Git Ignore"
        ];
      };
      description = ''
        Parameters to be written to the system-wide `bat` configuration file.
      '';
      inherit type;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ] ++ cfg.extraPackages;
      etc."bat/config".source = generate "bat-config" (
        mapAttrs' (name: value: nameValuePair ("--" + name) (recursiveToString value)) cfg.settings
      );
    };

    programs = {
      bash = mkIf (!config.programs.fish.enable) {
        interactiveShellInit = shellInit "bash";
      };
      fish = mkIf config.programs.fish.enable {
        interactiveShellInit = shellInit "fish";
      };
      zsh = mkIf (!config.programs.fish.enable && config.programs.zsh.enable) {
        interactiveShellInit = shellInit "zsh";
      };
    };
  };
  meta.maintainers = with maintainers; [ sigmasquadron ];
}
