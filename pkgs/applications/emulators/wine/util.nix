{ lib }:
rec {
  toPackages = pkgNames: pkgs:
    map (pn: lib.getAttr pn pkgs) pkgNames;
  toBuildInputs = pkgArches: archPkgs:
    lib.concatLists (map archPkgs pkgArches);
  mkBuildInputs = pkgArches: pkgNames:
    toBuildInputs pkgArches (toPackages pkgNames);
}
