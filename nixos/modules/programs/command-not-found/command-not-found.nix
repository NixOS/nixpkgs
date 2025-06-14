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
      default = true;
      description = ''
        Whether interactive shells should show which Nix package (if
        any) provides a missing command.

        This option does not take effect when using flakes.
        Flake users should use `programs.nix-index.enable` instead.
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
      # This function is called whenever a command is not found.
      command_not_found_handle() {
        local p='${cfg.package}/bin/command-not-found'
        if [ -x "$p" ] && [ -f '${cfg.package.passthru.dbPath}' ]; then
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

    programs.zsh.interactiveShellInit = ''
      # This function is called whenever a command is not found.
      command_not_found_handler() {
        local p='${cfg.package}/bin/command-not-found'
        if [ -x "$p" ] && [ -f '${cfg.package.passthru.dbPath}' ]; then
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

    environment.systemPackages = [ cfg.package ];
  };

}
