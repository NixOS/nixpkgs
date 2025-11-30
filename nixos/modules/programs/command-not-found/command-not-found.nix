# This module provides suggestions of packages to install if the user
# tries to run a missing command in Bash.  This is implemented using a
# SQLite database that maps program names to Nix package names (e.g.,
# "pdflatex" is mapped to "tetex").

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.command-not-found;
  commandNotFound = pkgs.replaceVarsWith {
    name = "command-not-found";
    dir = "bin";
    src = ./command-not-found.pl;
    isExecutable = true;
    replacements = {
      inherit (cfg) dbPath;
      perl = pkgs.perl.withPackages (p: [
        p.DBDSQLite
        p.StringShellQuote
      ]);
    };
  };

in

{
  options.programs.command-not-found = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether interactive shells should show which Nix package (if
        any) provides a missing command.

        Requires nix-channels to be set and downloaded (sudo nix-channels --update.)

        See also nix-index and nix-index-database as an alternative for flakes-based systems.

        Additionally, having the env var NIX_AUTO_RUN set will automatically run the matching package, and with NIX_AUTO_RUN_INTERACTIVE it will confirm the package before running.
      '';
    };

    dbPath = lib.mkOption {
      default = "/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite";
      description = ''
        Absolute path to programs.sqlite.

        By default this file will be provided by your channel
        (nixexprs.tar.xz).
      '';
      type = lib.types.path;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash.interactiveShellInit = ''
      command_not_found_handle() {
        '${commandNotFound}/bin/command-not-found' "$@"
      }
    '';

    programs.zsh.interactiveShellInit = ''
      command_not_found_handler() {
        '${commandNotFound}/bin/command-not-found' "$@"
      }
    '';

    # NOTE: Fish by itself checks for nixos command-not-found, let's instead makes it explicit.
    programs.fish.interactiveShellInit = ''
      function fish_command_not_found
         "${commandNotFound}/bin/command-not-found" $argv
      end
    '';

    environment.systemPackages = [ commandNotFound ];
  };

}
