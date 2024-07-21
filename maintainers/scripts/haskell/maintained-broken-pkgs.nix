let
  nixpkgs = import ../../..;
  inherit (nixpkgs {}) haskellPackages lib;
  maintainedPkgs = lib.filterAttrs (
    _: v: builtins.length (v.meta.maintainers or []) > 0
  ) haskellPackages;
  brokenPkgs = lib.filterAttrs (_: v: v.meta.broken) maintainedPkgs;
  transitiveBrokenPkgs = lib.filterAttrs
    (_: v: !(builtins.tryEval (v.outPath or null)).success && !v.meta.broken)
    maintainedPkgs;
  infoList = pkgs: lib.concatStringsSep "\n" (lib.mapAttrsToList (name: drv: "${name} ${(builtins.elemAt drv.meta.maintainers 0).github}") pkgs);
in {
  report = ''
    BROKEN:
    ${infoList brokenPkgs}

    TRANSITIVE BROKEN:
    ${infoList transitiveBrokenPkgs}
  '';
  transitiveErrors =
    builtins.attrValues transitiveBrokenPkgs;
}
