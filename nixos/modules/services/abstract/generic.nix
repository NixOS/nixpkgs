# This module is valid for all implementations of the service abstraction layer,
# and might even be vendored from another repo or moved outside of nixpkgs/nixos/
# into nixpkgs/something.

{ lib, config, options, pkgs, ... }:
let
  inherit (lib) mkOption types;
in
{
  options = {
    services.abstract = mkOption {
      type = types.lazyAttrsOf (types.submoduleWith {
        modules = [
          ./instance/generic.nix
          { _module.args.pkgs = pkgs; }
        ]; });
      default = { };
      description = ''
        All services that are configured on the system.
      '';
    };
  };
}