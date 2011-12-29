# This module defines global configuration for the Bash shell, in
# particular /etc/bashrc and /etc/profile.

{ config, pkgs, ... }:

with pkgs.lib;

let

  options = {

    environment.shellInit = mkOption {
        default = "";
        example = ''export PATH=/godi/bin/:$PATH'';
        description = "
          Script used to initialized user shell environments.
        ";
        type = with pkgs.lib.types; string;
      };

  };

in

{
  require = [options];

  environment.etc =
    [ { # Script executed when the shell starts as a login shell.
        source = pkgs.substituteAll {
          src = ./profile.sh;
          wrapperDir = config.security.wrapperDir;
          modulesTree = config.system.modulesTree;
          shellInit = config.environment.shellInit;
        };
        target = "profile";
      }

      { # /etc/bashrc: executed every time a bash starts. Sources
        # /etc/profile to ensure that the system environment is
        # configured properly.
         source = ./bashrc.sh;
         target = "bashrc";
      }

      { # Configuration for readline in bash.
        source = ./inputrc;
        target = "inputrc";
      }
    ];

  system.build.binsh = pkgs.bashInteractive;

  system.activationScripts.binsh = stringAfter [ "stdio" ]
    ''
      # Create the required /bin/sh symlink; otherwise lots of things
      # (notably the system() function) won't work.
      mkdir -m 0755 -p /bin
      ln -sfn ${config.system.build.binsh}/bin/sh /bin/sh
    '';

}
