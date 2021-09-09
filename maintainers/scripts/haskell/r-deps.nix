let
  pkgs = import ../../.. {};
  inherit (pkgs) lib;
  merge = attrs: nextName: attrs // { "${nextName}" = (attrs.${nextName} or 0) + 1; };
  getDeps = _: pkg: builtins.filter (x: !isNull x) (map (x: x.pname or null) (pkg.propagatedBuildInputs or []));
  isBroken = _: pkg: pkg.meta.broken or false;
in
  {
    all = builtins.foldl' merge {} (lib.flatten (lib.mapAttrsToList getDeps pkgs.haskellPackages));
    broken = builtins.foldl' merge {} (lib.flatten (lib.mapAttrsToList getDeps (lib.filterAttrs isBroken pkgs.haskellPackages)));
  }
