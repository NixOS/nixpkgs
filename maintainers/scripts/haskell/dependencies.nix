# Nix script to calculate the Haskell dependencies of every haskellPackage. Used by ./hydra-report.hs.
let
  pkgs = import ../../.. {};
  inherit (pkgs) lib;
  getDeps = _: pkg: {
    deps = builtins.filter (x: x != null) (map (x: x.pname or null) (pkg.propagatedBuildInputs or []));
    broken = (pkg.meta.hydraPlatforms or [null]) == [];
  };
in
  lib.mapAttrs getDeps pkgs.haskellPackages
