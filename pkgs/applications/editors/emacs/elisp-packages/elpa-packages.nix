{ lib, pkgs, buildPackages }:

self: let

  inherit (import ./lib-override-helper.nix pkgs lib)
    markBroken
    ;

  # Use custom elpa url fetcher with fallback/uncompress
  fetchurl = buildPackages.callPackage ./fetchelpa.nix { };

  generateElpa = lib.makeOverridable ({
    generated ? ./elpa-generated.nix
  }: let

    imported = import generated {
      callPackage = pkgs: args: self.callPackage pkgs (args // {
        inherit fetchurl;
      });
    };

    super = imported;

    commonOverrides = import ./elpa-common-overrides.nix pkgs lib buildPackages;

    overrides = self: super: {
      # upstream issue: Wrong type argument: arrayp, nil
      org-transclusion =
        if super.org-transclusion.version == "1.2.0"
        then markBroken super.org-transclusion
        else super.org-transclusion;
      rcirc-menu = markBroken super.rcirc-menu; # Missing file header


    };

    elpaPackages =
      let super' = super // (commonOverrides self super); in super' // (overrides self super');

  in elpaPackages);

in
generateElpa { }
