# This module defines global configuration for the Bash shell, in
# particular /etc/bashrc and /etc/profile.

{ config, pkgs, ... }:

with pkgs.lib;

let

  initBashCompletion = optionalString config.environment.enableBashCompletion ''
    # Check whether we're running a version of Bash that has support for
    # programmable completion. If we do, enable all modules installed in
    # the system (and user profile).
    if shopt -q progcomp &>/dev/null; then
      . "${pkgs.bashCompletion}/etc/profile.d/bash_completion.sh"
      nullglobStatus=$(shopt -p nullglob)
      shopt -s nullglob
      for p in $NIX_PROFILES /run/current-system/sw; do
        for m in "$p/etc/bash_completion.d/"*; do
          echo enable bash completion module $m
          . $m
        done
      done
      eval "$nullglobStatus"
    fi
  '';


  options = {

    environment.shellInit = mkOption {
        default = "";
        example = ''export PATH=/godi/bin/:$PATH'';
        description = "
          Script used to initialized user shell environments.
        ";
        type = with pkgs.lib.types; string;
      };

    environment.enableBashCompletion = mkOption {
        default = false;
        description = "Enable bash-completion for all interactive shells.";
        type = with pkgs.lib.types; bool;
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
          shellInit = config.environment.shellInit;
        };
        target = "profile";
      }

      { # /etc/bashrc: executed every time a bash starts. Sources
        # /etc/profile to ensure that the system environment is
        # configured properly.
         source = pkgs.substituteAll {
           src = ./bashrc.sh;
           inherit initBashCompletion;
         };
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
      ln -sfn ${config.system.build.binsh}/bin/sh /bin/.sh.tmp
      mv /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
    '';

  environment.pathsToLink = optional config.environment.enableBashCompletion "/etc/bash_completion.d";
}
