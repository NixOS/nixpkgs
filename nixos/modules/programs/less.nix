{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.less;

  configFile = ''
    #command
    ${concatStringsSep "\n"
      (mapAttrsToList (command: action: "${command} ${action}") cfg.commands)
    }
    ${if cfg.clearDefaultCommands then "#stop" else ""}

    #line-edit
    ${concatStringsSep "\n"
      (mapAttrsToList (command: action: "${command} ${action}") cfg.lineEditingKeys)
    }

    #env
    ${concatStringsSep "\n"
      (mapAttrsToList (variable: values: "${variable}=${values}") cfg.envVariables)
    }
  '';

  lessKey = pkgs.runCommand "lesskey"
            { src = pkgs.writeText "lessconfig" configFile; }
            "${pkgs.less}/bin/lesskey -o $out $src";

  lessPipe = pkgs.writeScriptBin "lesspipe.sh" ''
    #! /bin/sh
    case "$1" in
    *.gz)
        ${pkgs.gzip}/bin/gunzip --stdout "$1" 2>/dev/null
        ;;
    *.xz)
        ${pkgs.xz}/bin/unxz --stdout "$1" 2>/dev/null
        ;;
    *.bz2)
        ${pkgs.bzip2}/bin/bunzip2 --stdout "$1" 2>/dev/null
        ;;
    *)  exit 1
        ;;
    esac
    exit $?
  '';

in

{
  options = {

    programs.less = {

      enable = mkEnableOption "less";

      commands = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {
          "h" = "noaction 5\e(";
          "l" = "noaction 5\e)";
        };
        description = "Defines new command keys.";
      };

      clearDefaultCommands = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Clear all default commands.
          You should remember to set the quit key.
          Otherwise you will not be able to leave less without killing it.
        '';
      };

      lineEditingKeys = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {
          "\e" = "abort";
        };
        description = "Defines new line-editing keys.";
      };

      envVariables = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {
          LESS = "--quit-if-one-screen";
        };
        description = "Defines environment variables.";
      };

      autoExtract = mkOption {
        type = types.bool;
        default = true;
        description = ''
          When enabled less automatically extracts .gz .xz .bz2 files before reading them.
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.less ];

    environment.variables."LESSKEY_SYSTEM" = toString lessKey;
    environment.variables."LESSOPEN" = "|${lessPipe}/bin/lesspipe.sh %s";

    warnings = optional (
      cfg.clearDefaultCommands && (all (x: x != "quit") (attrValues cfg.commands))
    ) ''
      config.programs.less.clearDefaultCommands clears all default commands of less but there is no alternative binding for exiting.
      Consider adding a binding for 'quit'.
    '';
  };

  meta.maintainers = with maintainers; [ johnazoidberg ];

}
