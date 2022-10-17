{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.less;

  configText = if (cfg.configFile != null) then (builtins.readFile cfg.configFile) else ''
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

  lessKey = pkgs.writeText "lessconfig" configText;

in

{
  options = {

    programs.less = {

      # note that environment.nix sets PAGER=less, and
      # therefore also enables this module
      enable = mkEnableOption (lib.mdDoc "less");

      configFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = literalExpression ''"''${pkgs.my-configs}/lesskey"'';
        description = lib.mdDoc ''
          Path to lesskey configuration file.

          {option}`configFile` takes precedence over {option}`commands`,
          {option}`clearDefaultCommands`, {option}`lineEditingKeys`, and
          {option}`envVariables`.
        '';
      };

      commands = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {
          h = "noaction 5\\e(";
          l = "noaction 5\\e)";
        };
        description = lib.mdDoc "Defines new command keys.";
      };

      clearDefaultCommands = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Clear all default commands.
          You should remember to set the quit key.
          Otherwise you will not be able to leave less without killing it.
        '';
      };

      lineEditingKeys = mkOption {
        type = types.attrsOf types.str;
        default = {};
        example = {
          e = "abort";
        };
        description = lib.mdDoc "Defines new line-editing keys.";
      };

      envVariables = mkOption {
        type = types.attrsOf types.str;
        default = {
          LESS = "-R";
        };
        example = {
          LESS = "--quit-if-one-screen";
        };
        description = lib.mdDoc "Defines environment variables.";
      };

      lessopen = mkOption {
        type = types.nullOr types.str;
        default = "|${pkgs.lesspipe}/bin/lesspipe.sh %s";
        defaultText = literalExpression ''"|''${pkgs.lesspipe}/bin/lesspipe.sh %s"'';
        description = lib.mdDoc ''
          Before less opens a file, it first gives your input preprocessor a chance to modify the way the contents of the file are displayed.
        '';
      };

      lessclose = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc ''
          When less closes a file opened in such a way, it will call another program, called the input postprocessor, which may  perform  any  desired  clean-up  action (such  as deleting the replacement file created by LESSOPEN).
        '';
      };
    };
  };

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.less ];

    environment.variables = {
      LESSKEYIN_SYSTEM = toString lessKey;
    } // optionalAttrs (cfg.lessopen != null) {
      LESSOPEN = cfg.lessopen;
    } // optionalAttrs (cfg.lessclose != null) {
      LESSCLOSE = cfg.lessclose;
    };

    warnings = optional (
      cfg.clearDefaultCommands && (all (x: x != "quit") (attrValues cfg.commands))
    ) ''
      config.programs.less.clearDefaultCommands clears all default commands of less but there is no alternative binding for exiting.
      Consider adding a binding for 'quit'.
    '';
  };

  meta.maintainers = with maintainers; [ johnazoidberg ];

}
