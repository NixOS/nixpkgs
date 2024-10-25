{
  lib,
  pkgs,
  buildPackages,
}:

self:
let

  inherit (import ./lib-override-helper.nix pkgs lib)
    addPackageRequires
    ;

  generateNongnu = lib.makeOverridable (
    {
      generated ? ./nongnu-devel-generated.nix,
    }:
    let

      imported = import generated {
        callPackage =
          pkgs: args:
          self.callPackage pkgs (
            args
            // {
              # Use custom elpa url fetcher with fallback/uncompress
              fetchurl = buildPackages.callPackage ./fetchelpa.nix { };
            }
          );
      };

      super = imported;

      commonOverrides = import ./nongnu-common-overrides.nix pkgs lib;

      overrides = self: super: {
        # missing optional dependencies
        haskell-tng-mode = addPackageRequires super.haskell-tng-mode [
          self.shut-up
          self.lsp-mode
        ];
      };

    in
    let
      super' = super // (commonOverrides self super);
    in
    super' // (overrides self super')
  );

in
generateNongnu { }
