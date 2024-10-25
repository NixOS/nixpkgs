{ lib, pkgs, buildPackages }:

self: let

  generateNongnu = lib.makeOverridable ({
    generated ? ./nongnu-generated.nix
  }: let

    imported = import generated {
      callPackage = pkgs: args: self.callPackage pkgs (args // {
        # Use custom elpa url fetcher with fallback/uncompress
        fetchurl = buildPackages.callPackage ./fetchelpa.nix { };
      });
    };

    super = imported;

    commonOverrides = import ./nongnu-common-overrides.nix pkgs lib;

    overrides = self: super: { };

  in
  let super' = super // (commonOverrides self super); in super' // (overrides self super'));

in generateNongnu { }
