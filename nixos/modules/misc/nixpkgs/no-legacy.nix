/*
  A clean, [RFC 0078] style implementation of the NixOS `nixpkgs.*` module, which
  is free of legacy options (as of 23.05).

  [RFC 0078]: https://github.com/NixOS/rfcs/pull/78
*/

{ config, lib, ... }:

{
  disabledModules = [
    # This replaces the traditional nixpkgs module
    ../nixpkgs.nix
  ];
  options = {
    nixpkgs = lib.mkOption {
      description = lib.mdDoc ''
        Options that configure the `pkgs` module argument.
      '';
      example = lib.literalExpression ''
        nixpkgs = {
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              # Patch nixpkgs here
            })
          ];
        };
      '';
      type = lib.types.submoduleWith {
        shorthandOnlyDefinesConfig = true;
        modules = [ ../../../../pkgs/top-level/module/module.nix ];
      };
    };
  };
  config = {
    _module.args.pkgs = config.nixpkgs.pkgs;
  };
}
