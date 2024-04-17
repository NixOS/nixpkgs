# This module provides suggestions of packages to install if the user
# tries to run a missing command in Bash.  This is implemented using a
# SQLite database that maps program names to Nix package names (e.g.,
# "pdflatex" is mapped to "tetex").

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.command-not-found;
  commandNotFound = pkgs.substituteAll {
    name = "command-not-found";
    dir = "bin";
    src = ./command-not-found.pl;
    isExecutable = true;
    inherit (cfg) dbPath;
    perl = pkgs.perl.withPackages (p: [ p.DBDSQLite p.StringShellQuote ]);
  };

in

{
  options.programs.command-not-found = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether interactive shells should show which Nix package (if
        any) provides a missing command.
      '';
    };

    dbPath = lib.mkOption {
      default = "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite" ;
      description = ''
        Absolute path to programs.sqlite.

        By default this file will be provided by your channel
        (nixexprs.tar.xz).
      '';
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash.interactiveShellInit =
      ''
        # This function is called whenever a command is not found.
        command_not_found_handle() {
          local p='${commandNotFound}/bin/command-not-found'
          if [ -x "$p" ] && [ -f '${cfg.dbPath}' ]; then
            # Run the helper program.
            "$p" "$@"
            # Retry the command if we just installed it.
            if [ $? = 126 ]; then
              "$@"
            else
              return 127
            fi
          else
            echo "$1: command not found" >&2
            return 127
          fi
        }
      '';

    programs.zsh.interactiveShellInit =
      ''
        # This function is called whenever a command is not found.
        command_not_found_handler() {
          local p='${commandNotFound}/bin/command-not-found'
          if [ -x "$p" ] && [ -f '${cfg.dbPath}' ]; then
            # Run the helper program.
            "$p" "$@"

            # Retry the command if we just installed it.
            if [ $? = 126 ]; then
              "$@"
            else
              return 127
            fi
          else
            # Indicate than there was an error so ZSH falls back to its default handler
            echo "$1: command not found" >&2
            return 127
          fi
        }
      '';

    environment.systemPackages = [ commandNotFound ];
  };

}
