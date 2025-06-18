{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.programs.less;

  configText =
    if (cfg.configFile != null) then
      (builtins.readFile cfg.configFile)
    else
      ''
        #command
        ${builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (command: action: "${command} ${action}") cfg.commands
        )}
        ${lib.optionalString cfg.clearDefaultCommands "#stop"}

        #line-edit
        ${builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (command: action: "${command} ${action}") cfg.lineEditingKeys
        )}

        #env
        ${builtins.concatStringsSep "\n" (
          lib.mapAttrsToList (variable: values: "${variable}=${values}") cfg.envVariables
        )}
      '';

  lessKey = pkgs.writeText "lessconfig" configText;

in

{
  options = {

    programs.less = {

      # note that environment.nix sets PAGER=less, and
      # therefore also enables this module
      enable = lib.mkEnableOption "less, a file pager";

      package = lib.mkPackageOption pkgs "less" { };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = lib.literalExpression ''"''${pkgs.my-configs}/lesskey"'';
        description = ''
          Path to lesskey configuration file.

          {option}`configFile` takes precedence over {option}`commands`,
          {option}`clearDefaultCommands`, {option}`lineEditingKeys`, and
          {option}`envVariables`.
        '';
      };

      commands = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          h = "noaction 5\\e(";
          l = "noaction 5\\e)";
        };
        description = "Defines new command keys.";
      };

      clearDefaultCommands = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Clear all default commands.
          You should remember to set the quit key.
          Otherwise you will not be able to leave less without killing it.
        '';
      };

      lineEditingKeys = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        example = {
          e = "abort";
        };
        description = "Defines new line-editing keys.";
      };

      envVariables = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = {
          LESS = "-R";
        };
        example = {
          LESS = "--quit-if-one-screen";
        };
        description = "Defines environment variables.";
      };

      lessopen = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = lib.literalExpression ''"|''${pkgs.lesspipe}/bin/lesspipe.sh %s"'';
        description = ''
          Before less opens a file, it first gives your input preprocessor a chance to modify the way the contents of the file are displayed.
        '';
      };

      lessclose = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          When less closes a file opened in such a way, it will call another program, called the input postprocessor,
          which may perform any desired clean-up action (such as deleting the replacement file created by LESSOPEN).
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    environment.variables =
      {
        LESSKEYIN_SYSTEM = builtins.toString lessKey;
      }
      // lib.optionalAttrs (cfg.lessopen != null) {
        LESSOPEN = cfg.lessopen;
      }
      // lib.optionalAttrs (cfg.lessclose != null) {
        LESSCLOSE = cfg.lessclose;
      };

    warnings =
      lib.optional
        (cfg.clearDefaultCommands && (builtins.all (x: x != "quit") (builtins.attrValues cfg.commands)))
        ''
          config.programs.less.clearDefaultCommands clears all default commands of less but there is no alternative binding for exiting.
          Consider adding a binding for 'quit'.
        '';
  };

  meta.maintainers = with lib.maintainers; [ johnazoidberg ];

}
