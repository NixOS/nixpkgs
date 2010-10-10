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
        merge = mergeStringOption;
      };

  };

in    
   
{
  require = [options];

  environment.etc =
    [ { # /etc/bashrc: script executed when the shell starts as a
        # non-login shell.  /etc/profile also sources this file, so
        # most global configuration (such as environment variables)
        # should go into this script.
        source = pkgs.substituteAll {
          src = ./bashrc.sh;

          bash = pkgs.bash;
          wrapperDir = config.security.wrapperDir;
          modulesTree = config.system.modulesTree;
          shellInit = config.environment.shellInit;
        };
        target = "bashrc";
      }

      { # Script executed when the shell starts as a login shell.
        source = ./profile.sh;
        target = "profile";
      }

      { # Template for ~/.bashrc: script executed when the shell
        # starts as a non-login shell.
        source = ./bashrc-user.sh;
        target = "skel/.bashrc";
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
