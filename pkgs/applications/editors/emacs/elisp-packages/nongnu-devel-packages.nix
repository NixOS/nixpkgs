/*
  # Updating

  To update the list of packages from nongnu devel (ELPA),

  1. Run `./update-nongnu-devel`.
  2. Check for evaluation errors:
       # "../../../../../" points to the default.nix from root of Nixpkgs tree
       env NIXPKGS_ALLOW_BROKEN=1 nix-instantiate ../../../../../ -A emacs.pkgs.nongnuDevelPackages
  3. Run `git commit -m "nongnu-devel-packages $(date -Idate)" -- nongnu-devel-generated.nix`
*/

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
        # keep-sorted start block=yes newline_separated=yes
        # missing optional dependencies
        haskell-tng-mode = addPackageRequires super.haskell-tng-mode [
          self.shut-up
          self.lsp-mode
        ];
        # keep-sorted end
      };

    in
    let
      super' = super // (commonOverrides self super);
    in
    super' // (overrides self super')
  );

in
generateNongnu { }
