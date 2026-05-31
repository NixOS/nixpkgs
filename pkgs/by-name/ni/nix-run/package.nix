{ lib, haskellPackages }:
(haskellPackages.callPackage ./nix-run.nix { }).overrideAttrs (old: {
  meta = old.meta // {
    description = "A non-experimental replacement for nix run";
    maintainers = [ lib.maintainers.WeetHet ];
  };
})
