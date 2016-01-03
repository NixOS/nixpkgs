# This module provides suggestions of packages to install if the user
# tries to run a missing command in Bash.  This is implemented using a
# SQLite database that maps program names to Nix package names (e.g.,
# "pdflatex" is mapped to "tetex").

{ config, lib, pkgs, ... }:

with lib;

let

  commandNotFound = pkgs.substituteAll {
    name = "command-not-found";
    dir = "bin";
    src = ./command-not-found.pl;
    isExecutable = true;
    inherit (pkgs) perl;
    perlFlags = concatStrings (map (path: "-I ${path}/lib/perl5/site_perl ")
      [ pkgs.perlPackages.DBI pkgs.perlPackages.DBDSQLite pkgs.perlPackages.StringShellQuote ]);
  };

in

{

  programs.bash.interactiveShellInit =
    ''
      # This function is called whenever a command is not found.
      command_not_found_handle() {
        local p=/run/current-system/sw/bin/command-not-found
        if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
          # Run the helper program.
          $p "$@"
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
        local p=/run/current-system/sw/bin/command-not-found
        if [ -x $p -a -f /nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite ]; then
          # Run the helper program.
          $p "$@"

          # Retry the command if we just installed it.
          if [ $? = 126 ]; then
            "$@"
          fi
        else
          # Indicate than there was an error so ZSH falls back to its default handler
          return 127
        fi
      }
    '';

  environment.systemPackages = [ commandNotFound ];

  # TODO: tab completion for uninstalled commands! :-)

}
