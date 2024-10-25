{ lib, pkgs, buildPackages }:

self: let

  inherit (import ./lib-override-helper.nix pkgs lib)
    markBroken
    ;

  # Use custom elpa url fetcher with fallback/uncompress
  fetchurl = buildPackages.callPackage ./fetchelpa.nix { };

  generateElpa = lib.makeOverridable ({
    generated ? ./elpa-devel-generated.nix
  }: let

    imported = import generated {
      callPackage = pkgs: args: self.callPackage pkgs (args // {
        inherit fetchurl;
      });
    };

    super = imported;

    commonOverrides = import ./elpa-common-overrides.nix pkgs lib buildPackages;

    overrides = self: super: {
    };

    elpaDevelPackages =
      let super' = super // (commonOverrides self super); in super' // (overrides self super');

  in elpaDevelPackages);

in generateElpa { }
