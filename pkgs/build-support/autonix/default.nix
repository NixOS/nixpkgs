{ pkgs }:

let inherit (pkgs) bash coreutils findutils nix wget;
    inherit (pkgs) callPackage fetchurl runCommand stdenv substituteAll writeText;
in

/* autonix is a collection of tools to automate packaging large collections
 * of software, particularly KDE. It consists of three components:
 *   1. a script (manifest) to download and hash the packages
 *   2. a dependency scanner (autonix-deps) written in Haskell that examines
 *      the package sources and tries to guess their dependencies
 *   3. a library of Nix routines (generateCollection) to generate Nix
 *      expressions from the output of the previous steps.
 */

let inherit (stdenv) lib; in

let

  resolveDeps = scope: deps:
    let resolve = dep:
          let res = scope."${dep}" or [];
          in if lib.isList res then res else [res];
    in lib.concatMap resolve deps;

in rec {

  /* Download the packages into the Nix store, compute their hashes,
   * and generate a package manifest in ./manifest.nix.
   */
  manifest =
    let
      script =
        substituteAll
          {
            src = ./manifest.sh;
            inherit bash coreutils findutils nix wget;
          };
    in
      runCommand "autonix-manifest" {}
        ''
          cp ${script} $out
          chmod +x $out
        '';

  mkPackage = callPackage: defaultOverride: name: pkg: let drv =
    { mkDerivation, fetchurl, scope }:

    mkDerivation (defaultOverride {
      inherit (pkg) name;

      src = fetchurl pkg.src;

      buildInputs = resolveDeps scope pkg.buildInputs;
      nativeBuildInputs = resolveDeps scope pkg.nativeBuildInputs;
      propagatedBuildInputs = resolveDeps scope pkg.propagatedBuildInputs;
      propagatedNativeBuildInputs =
        resolveDeps scope pkg.propagatedNativeBuildInputs;
      propagatedUserEnvPkgs = resolveDeps scope pkg.propagatedUserEnvPkgs;

      enableParallelBuilding = true;
    });
  in callPackage drv {};

  renameDeps = renames: lib.mapAttrs (name: pkg:
    let breakCycles = lib.filter (dep: dep != name);
        rename = dep: renames."${dep}" or dep;
    in pkg // {
      buildInputs = breakCycles (map rename pkg.buildInputs);
      nativeBuildInputs = breakCycles (map rename pkg.nativeBuildInputs);
      propagatedBuildInputs = breakCycles (map rename pkg.propagatedBuildInputs);
      propagatedNativeBuildInputs =
        breakCycles (map rename pkg.propagatedNativeBuildInputs);
      propagatedUserEnvPkgs = breakCycles (map rename pkg.propagatedUserEnvPkgs);
    });

  propagateDeps = propagated: lib.mapAttrs (name: pkg:
    let isPropagated = dep: lib.elem dep propagated;
        isNotPropagated = dep: !(isPropagated dep);
    in pkg // {
      buildInputs = lib.filter isNotPropagated pkg.buildInputs;
      nativeBuildInputs = lib.filter isNotPropagated pkg.nativeBuildInputs;
      propagatedBuildInputs =
        pkg.propagatedBuildInputs
        ++ lib.filter isPropagated pkg.buildInputs;
      propagatedNativeBuildInputs =
        pkg.propagatedNativeBuildInputs
        ++ lib.filter isPropagated pkg.nativeBuildInputs;
    });

  nativeDeps = native: lib.mapAttrs (name: pkg:
    let isNative = dep: lib.elem dep native;
        isNotNative = dep: !(isNative dep);
    in pkg // {
      buildInputs = lib.filter isNotNative pkg.buildInputs;
      nativeBuildInputs =
        pkg.nativeBuildInputs
        ++ lib.filter isNative pkg.buildInputs;
      propagatedBuildInputs = lib.filter isNotNative pkg.propagatedBuildInputs;
      propagatedNativeBuildInputs =
        pkg.propagatedNativeBuildInputs
        ++ lib.filter isNative pkg.propagatedBuildInputs;
    });

  userEnvDeps = user: lib.mapAttrs (name: pkg:
    let allDeps = with pkg; lib.concatLists [
          buildInputs
          nativeBuildInputs
          propagatedBuildInputs
          propagatedNativeBuildInputs
        ];
    in assert (lib.isList allDeps); pkg // {
      propagatedUserEnvPkgs = lib.filter (dep: lib.elem dep user) allDeps;
    });

  overrideDerivation = pkg: f: pkg.override (super: super // {
    mkDerivation = drv: super.mkDerivation (drv // f drv);
  });

  extendDerivation = pkg: attrs:
    let mergeAttrBy = lib.mergeAttrBy // {
          propagatedNativeBuildInputs = a: b: a ++ b;
          NIX_CFLAGS_COMPILE = a: b: "${a} ${b}";
          cmakeFlags = a: b: a ++ b;
        };
        mergeAttrsByFunc = sets:
          let merged = lib.foldl lib.mergeAttrByFunc { inherit mergeAttrBy; } sets;
          in builtins.removeAttrs merged ["mergeAttrBy"];
    in overrideDerivation pkg (drv: mergeAttrsByFunc [ drv attrs ]);

  overrideScope = pkg: fnOrSet: pkg.override (super: super // {
    scope = if builtins.isFunction fnOrSet
              then super.scope // fnOrSet super.scope
            else super.scope // fnOrSet;
  });
}
