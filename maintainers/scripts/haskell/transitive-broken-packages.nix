let
  nixpkgs = import ../../..;
  inherit (nixpkgs { }) pkgs lib;
  isVersioned = attr: builtins.match "[A-Za-z0-9-]+(_[0-9]+)+" attr != null;
  getEvaluating =
    x:
    lib.mapAttrsToList (_: v: v.pname) (
      lib.filterAttrs (
        n: v:
        !(isVersioned n)
        && (builtins.tryEval (v.outPath or null)).success
        && lib.isDerivation v
        && !v.meta.broken
      ) x
    );
  brokenDeps = lib.subtractLists (getEvaluating pkgs.haskellPackages) (
    getEvaluating (nixpkgs { config.allowBroken = true; }).haskellPackages
  );
in
''
  ${lib.concatMapStringsSep "\n" (x: " - ${x}") brokenDeps}
''
