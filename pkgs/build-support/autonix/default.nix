{ bash, callPackage, coreutils, fetchurl, findutils, nix, runCommand, stdenv
, substituteAll, wget, writeText }:

/* autonix is a collection of tools to automate packaging large collections
 * of software, particularly KDE. It consists of three components:
 *   1. a script (manifest) to download and hash the packages
 *   2. a dependency scanner (autonix-deps) written in Haskell that examines
 *      the package sources and tries to guess their dependencies
 *   3. a library of Nix routines (generateCollection) to generate Nix
 *      expressions from the output of the previous steps.
 */

with stdenv.lib;

let

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

  /* Convert a manifest.nix file to XML to be read by autonix-deps. */
  writeManifestXML = filename:
    let
      generateStores = mapAttrs (n: pkg: pkg.store);
      manifest = importManifest filename { mirror = ""; };
      stores = generateStores manifest;
    in
      writeText "manifest.xml" (builtins.toXML stores);

  /* Generate a set of Nix expressions for the collection, given a
   * manifest.nix, dependencies.nix, and renames.nix in the same directory.
   */
  generateCollection = dir: # path to directory
    { mirror # mirror to download packages from
    , mkDerivation ? mkDerivation
    , preResolve ? id # modify package set before dependency resolution
    , postResolve ? id # modify package set after dependency resolution
    , renames ? {}
    , scope ? {}
    }:
    let

      fix = f: let x = f x; in x;

      resolvePkg = name:
        mapAttrs (attr: if isDepAttr attr then resolveDeps scope else id);

      resolve = mapAttrs resolvePkg;

      derive = mapAttrs (name: mkDerivation);

      renames_ =
        if renames == {} then (import (dir + "/renames.nix") {}) else renames;

      packages = importPackages dir renames_ { inherit mirror; };

    in derive (postResolve (resolve (preResolve packages)));

  pkgAttrName = pkg: (builtins.parseDrvName pkg.name).name;
  pkgVersion = pkg: (builtins.parseDrvName pkg.name).version;

  depAttrNames = [
    "buildInputs" "nativeBuildInputs"
    "propagatedBuildInputs" "propagatedNativeBuildInputs"
    "propagatedUserEnvPkgs"
  ];

  isDepAttr = name: builtins.elem name depAttrNames;

  removePkgDeps = deps:
    let removeDepsIfDepAttr = attr: value:
          if isDepAttr attr then fold remove value deps else value;
    in mapAttrs removeDepsIfDepAttr;

  hasDep = dep: pkg:
    let depAttrs = attrValues (filterAttrs (n: v: isDepAttr n) pkg);
        allDeps = concatLists depAttrs;
    in elem dep allDeps;

  importManifest = path: { mirror }:
    let
      uniqueNames = manifest:
        unique (map pkgAttrName manifest);

      versionsOf = manifest: name:
        filter (pkg: pkgAttrName pkg == name) manifest;

      bestVersions = manifest:
        let best = versions:
              let
                strictlyLess = a: b:
                  builtins.compareVersions (pkgVersion a) (pkgVersion b) > 0;
                sorted = sort strictlyLess versions;
              in head sorted;
        in map (name: best (versionsOf manifest name)) (uniqueNames manifest);

      withNames = manifest:
        builtins.listToAttrs
          (map (p: nameValuePair (toLower (pkgAttrName p)) p) manifest);

      orig = import path { inherit stdenv fetchurl mirror; };
    in
      fold (f: x: f x) orig [ withNames bestVersions ];

  importPackages = path: renames: manifestScope:
    let

      # Do not allow any package to depend on itself.
      breakRecursion =
        let removeSelfDep = pkg:
              mapAttrs
                (n: if isDepAttr n
                      then filter (dep: dep != pkg && renamed dep != pkg)
                    else id);
        in mapAttrs removeSelfDep;

      renamed = dep: renames."${dep}" or dep;

      manifest = importManifest (path + "/manifest.nix") manifestScope;

      deps = import (path + "/dependencies.nix") {};

      mkPkg = name: manifest:
        {
          inherit (manifest) name src;
          inherit (deps."${name}")
            buildInputs nativeBuildInputs propagatedBuildInputs
            propagatedNativeBuildInputs propagatedUserEnvPkgs;
        };

    in breakRecursion (mapAttrs mkPkg manifest);

  mkDerivation = drv: stdenv.mkDerivation (drv // { src = fetchurl drv.src; });

  resolveDeps = scope: deps:
    let resolve = dep:
          let res = scope."${dep}" or [];
          in if lib.isList res then res else [res];
    in lib.concatMap resolve deps;

  userEnvPkg = dep:
    mapAttrs
      (name: pkg: pkg // {
        propagatedUserEnvPkgs =
          (pkg.propagatedUserEnvPkgs or [])
          ++ optional (hasDep dep pkg) dep;
      });

in
{
  inherit generateCollection;
  inherit importManifest;
  inherit isDepAttr;
  inherit manifest;
  inherit removePkgDeps;
  inherit resolveDeps;
  inherit userEnvPkg;
  inherit writeManifestXML;

  blacklist = names: pkgs:
    let
      removeDeps = deps: mapAttrs (name: removePkgDeps deps);
      removePkgs = names: pkgs: builtins.removeAttrs pkgs names;
    in removeDeps names (removePkgs names pkgs);

  lib = rec {
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
        propagatedNativeBuildInputs = breakCycles (map rename pkg.propagatedNativeBuildInputs);
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
  };
}
