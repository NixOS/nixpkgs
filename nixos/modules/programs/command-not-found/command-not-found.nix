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
in
{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "programs"
        "command-not-found"
        "dbPath"
      ]
      "Use programs.command-not-found.package = pkgs.command-not-found.override { dbPath = \"\"; } instead."
    )
  ];
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

    package = lib.mkPackageOption pkgs "command-not-found" {
      extraDescription = ''
        To specify a custom `programs.sqlite` file, you can override the package as follows:

        package = pkgs.command-not-found.override { dbPath = "/absolute/path/to/programs.sqlite"; };

        By default, this file is provided by your channel via `nixexprs.tar.xz`.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash.interactiveShellInit = ''
      command_not_found_handle() {
        '${lib.getExe cfg.package}' "$@"
      }
    '';

    programs.zsh.interactiveShellInit = ''
      command_not_found_handler() {
        '${lib.getExe cfg.package}' "$@"
      }
    '';

    # NOTE: Fish by itself checks for nixos command-not-found, let's instead makes it explicit.
    programs.fish.interactiveShellInit = ''
      function fish_command_not_found
         "${lib.getExe cfg.package}" $argv
      end
    '';

    environment.systemPackages = [ cfg.package ];
  };

}
