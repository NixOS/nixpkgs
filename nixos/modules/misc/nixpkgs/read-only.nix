# A replacement for the traditional nixpkgs module, such that none of the modules
# can add their own configuration. This ensures that the Nixpkgs configuration is
# exactly as the user intends.
# This may also be used as a performance optimization when evaluating multiple
# configurations at once, with a shared `pkgs`.

# This is a separate module, because merging this logic into the nixpkgs module
# is too burdensome, considering that it is already burdened with legacy.
# Moving this logic into a module does not lose any composition benefits, because
# its purpose is not something that composes anyway.

{ lib, config, ... }:

let
  cfg = config.nixpkgs;
  inherit (lib) mkOption types;

in
{
  disabledModules = [
    ../nixpkgs.nix
  ];
  options = {
    nixpkgs = {
      pkgs = mkOption {
        type = lib.types.pkgs;
        description = ''The pkgs module argument.'';
      };
      config = mkOption {
        internal = true;
        type = types.unique { message = "nixpkgs.config is set to read-only"; } types.anything;
        description = ''
          The Nixpkgs `config` that `pkgs` was initialized with.
        '';
      };
      overlays = mkOption {
        internal = true;
        type = types.unique { message = "nixpkgs.overlays is set to read-only"; } types.anything;
        description = ''
          The Nixpkgs overlays that `pkgs` was initialized with.
        '';
      };
      # buildPlatform and hostPlatform left out on purpose:
      # - They are not supposed to be changed with this read-only module.
      # - They are not supposed to be read either, according to the description
      #   of "system" in the traditional nixpkgs module.
      #
      # NOTE: do not add the legacy options such as localSystem here. Let's keep
      #       this module simple and let module authors upgrade their code instead.
    };
  };
  config = {
    _module.args.pkgs =
      # find mistaken definitions
      builtins.seq cfg.config builtins.seq cfg.overlays cfg.pkgs;
    nixpkgs.config = cfg.pkgs.config;
    nixpkgs.overlays = cfg.pkgs.overlays;
  };
}
