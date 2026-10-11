{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.rush;

  indent =
    lines:
    lib.pipe lines [
      (lib.splitString "\n")
      (builtins.filter (line: line != ""))
      (map (line: "  " + line))
      (builtins.concatStringsSep "\n")
    ];
in
{
  meta.maintainers = pkgs.rush.meta.maintainers;

  options.programs.rush = with lib.types; {
    enable = lib.mkEnableOption "Restricted User Shell.";

    package = lib.mkPackageOption pkgs "rush" { } // {
      type = shellPackage;
    };

    global = lib.mkOption {
      type = lines;
      description = "The `global` statement defines global settings.";
      default = "";
    };

    rules = lib.mkOption {
      type = attrsOf lines;
      default = { };

      description = ''
        The rule statement configures a GNU Rush rule. This is a block statement, which means that all
        statements located between it and the next rule statement (or end of file, whichever occurs first)
        modify the definition of that rule.
      '';
    };

    shell = lib.mkOption {
      readOnly = true;
      type = either shellPackage path;

      description = ''
        The resolved shell/wrapper path that users can inherit to set `rush` as their login shell.
        This is a convenience option for use in user definitions. Example:
          `users.users.alice = { inherit (config.programs.rush) shell; ... };`
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rush.shell = config.security.wrapperDir + "/rush";

    environment = {
      shells = [ cfg.shell ];
      systemPackages = [ cfg.package ];

      etc."rush.rc".text =
        lib.pipe
          [
            "# This file was created by the module `programs.rush`;"
            "rush 2.0"
            (lib.optionalString (cfg.global != "") "global\n${indent cfg.global}")
            (lib.optionals (cfg.rules != { }) (
              lib.mapAttrsToList (name: content: "rule ${name}\n${indent content}") cfg.rules
            ))
          ]
          [
            (lib.flatten)
            (builtins.filter (line: line != ""))
            (builtins.concatStringsSep "\n\n")
            (lib.mkDefault)
          ];
    };

    security.wrappers.rush = lib.mkDefault {
      group = "root";
      owner = "root";
      permissions = "u+rx,g+x,o+x";
      setgid = false;
      setuid = true;
      source = lib.getExe cfg.package;
    };
  };
}
