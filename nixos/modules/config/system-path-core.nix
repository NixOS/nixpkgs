{ config, lib, pkgs, ... }:
let
  inherit (lib)
    mkOption
    types
    literalExpression
    ;
in
{
  options = {

    environment = {

      systemPackages = mkOption {
        type = types.listOf types.package;
        default = [ ];
        example = literalExpression "[ pkgs.firefox pkgs.htop ]";
        description = ''
          The set of packages that appear in
          /run/current-system/sw.  These packages are
          automatically available to all users, and are
          automatically updated every time you rebuild the system
          configuration.  (The latter is the main difference with
          installing them in the default profile,
          <filename>/nix/var/nix/profiles/default</filename>.
        '';
      };

      pathsToLink = mkOption {
        type = types.listOf types.str;
        # Note: We need `/lib' to be among `pathsToLink' for NSS modules
        # to work.
        default = [ ];
        example = [ "/" ];
        description = "List of directories to be symlinked in <filename>/run/current-system/sw</filename>.";
      };

      extraOutputsToInstall = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "doc" "info" "devdoc" ];
        description = "List of additional package outputs to be symlinked into <filename>/run/current-system/sw</filename>.";
      };

      extraSetup = mkOption {
        type = types.lines;
        default = "";
        description = "Shell fragments to be run after the system environment has been created. This should only be used for things that need to modify the internals of the environment, e.g. generating MIME caches. The environment being built can be accessed at $out.";
      };

    };

    system = {

      path = mkOption {
        internal = true;
        description = ''
          The packages you want in the boot environment.
        '';
      };

    };

  };
  config = {
    environment.pathsToLink = [
      "/bin"
    ];

    system.path = pkgs.buildEnv {
      name = "system-path";
      paths = config.environment.systemPackages;
      inherit (config.environment) pathsToLink extraOutputsToInstall;
      ignoreCollisions = true;
      # !!! Hacky, should modularise.
      # outputs TODO: note that the tools will often not be linked by default
      postBuild =
        ''
          # Remove wrapped binaries, they shouldn't be accessible via PATH.
          find $out/bin -maxdepth 1 -name ".*-wrapped" -type l -delete

          ${config.environment.extraSetup}
        '';
    };

  };
}
