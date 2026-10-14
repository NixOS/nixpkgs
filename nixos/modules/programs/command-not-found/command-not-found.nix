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
  options.programs.command-not-found = {

    enable = lib.mkOption {
      type = lib.types.bool;
      default = builtins.pathExists config.programs.command-not-found.dbPath;
      defaultText = lib.literalExpression ''
        builtins.pathExists config.programs.command-not-found.dbPath
      '';
      description = ''
        Whether interactive shells should show which Nix package (if
        any) provides a missing command.

        See also nix-index and nix-index-database as an alternative for flakes-based systems.

        Additionally, having the env var NIX_AUTO_RUN set will automatically run the matching package, and with NIX_AUTO_RUN_INTERACTIVE it will confirm the package before running.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.command-not-found.override { inherit (cfg) dbPath; };
      defaultText = lib.literalExpression ''
        pkgs.command-not-found.override { inherit (cfg) dbPath; }
      '';
      description = ''
        You can use a completely different `command-not-found` script here if you wish.
      '';
    };

    dbPath = lib.mkOption {
      type = lib.types.path;
      default = pkgs.path + "/programs.sqlite";
      defaultText = lib.literalExpression ''
        pkgs.path + "/programs.sqlite"
      '';
      description = ''
        Absolute path to `programs.sqlite`, which contains mappings from binary names to package names.

        If a nixpkgs tarball from https://channels.nixos.org is used as the source of nixpkgs, this file will be provided and this option be set by default.

        To use the stateful `programs.sqlite` database, set this option to
        `/nix/var/nix/profiles/per-user/root/channels/nixos/programs.sqlite`.
        If you do so, you can update it with `sudo nix-channels --update`.
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
