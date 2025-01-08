{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (builtins) isList elem;

  cfg = config.programs.bat;

  settingsFormat = pkgs.formats.keyValue { listsAsDuplicateKeys = true; };
  inherit (settingsFormat) generate type;

  initScript =
    {
      program,
      shell,
      flags ? [ ],
    }:
    if (shell != "fish") then
      ''
        eval "$(${lib.getExe program} ${toString flags})"
      ''
    else
      ''
        ${lib.getExe program} ${toString flags} | source
      '';

  shellInit =
    shell:
    lib.optionalString (elem pkgs.bat-extras.batpipe cfg.extraPackages) (initScript {
      program = pkgs.bat-extras.batpipe;
      inherit shell;
    })
    + lib.optionalString (elem pkgs.bat-extras.batman cfg.extraPackages) (initScript {
      program = pkgs.bat-extras.batman;
      inherit shell;
      flags = [ "--export-env" ];
    });
in
{
  options.programs.bat = {
    enable = lib.mkEnableOption "`bat`, a {manpage}`cat(1)` clone with wings";

    package = lib.mkPackageOption pkgs "bat" { };

    extraPackages = lib.mkOption {
      default = [ ];
      example = lib.literalExpression ''
        with pkgs.bat-extras; [
          batdiff
          batman
          prettybat
        ];
      '';
      description = ''
        Extra `bat` scripts to be added to the system configuration.
      '';
      type = lib.types.listOf lib.types.package;
    };

    settings = lib.mkOption {
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

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ] ++ cfg.extraPackages;
      etc."bat/config".source = generate "bat-config" (
        lib.mapAttrs' (
          name: value:
          lib.nameValuePair ("--" + name) (
            if (isList value) then map (str: "\"${str}\"") value else "\"${value}\""
          )
        ) cfg.settings
      );
    };

    programs = {
      bash = lib.mkIf (!config.programs.fish.enable) {
        interactiveShellInit = shellInit "bash";
      };
      fish = lib.mkIf config.programs.fish.enable {
        interactiveShellInit = shellInit "fish";
      };
      zsh = lib.mkIf (!config.programs.fish.enable && config.programs.zsh.enable) {
        interactiveShellInit = shellInit "zsh";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ sigmasquadron ];
}
