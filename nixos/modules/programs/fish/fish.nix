# This module defines global configuration for the fish.

{ config, lib, pkgs, ... }:

with lib;

let

cfge = config.environment;

cfg = config.programs.fish;

fishAliases = concatStringsSep "\n" (
  mapAttrsFlatten (k: v: "alias ${k}='${v}'") cfg.shellAliases
);

in

{

  options = {

    programs.fish = {

      enable = mkOption {
        default = false;
        description = ''
          Whenever to configure fish as an interactive shell.
          '';
        type = types.bool;
      };

      shellAliases = mkOption {
        default = config.environment.shellAliases;
        description = ''
          Set of aliases for zsh shell. See <option>environment.shellAliases</option>
          for an option format description.
            '';
        type = types.attrs; # types.attrsOf types.stringOrPath;
      };

      shellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during fish shell initialisation.
        '';
        type = types.lines;
      };

      loginShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during fish login shell initialisation.
        '';
        type = types.lines;
      };

      interactiveShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during interactive fish initialisation.
        '';
        type = types.lines;
      };

      promptInit = mkOption {
        default = "";
        description = ''
          Shell script code used to initialise the fish prompt.
        '';
        type = types.lines;
      };

    };

  };

  config = mkIf cfg.enable {

    programs.fish = {

      shellInit = ''
        . ${config.system.build.setEnvironment}

        ${cfge.shellInit}
      '';

      loginShellInit = cfge.loginShellInit;

      interactiveShellInit = ''
        ${cfge.interactiveShellInit}

        ${cfg.promptInit}

        ${fishAliases}
      '';

    };

    environment.profileRelativeEnvVars = { };

    environment.systemPackages = [ pkgs.fish ];

    #users.defaultUserShell = mkDefault "/run/current-system/sw/bin/fish";

    environment.shells =
      [ "/run/current-system/sw/bin/fish"
        "/var/run/current-system/sw/bin/fish"
        "${pkgs.fish}/bin/fish"
      ];

  };

}

