{ lib
, symlinkJoin
, jq
, makeWrapper
, extraPkgsByOverride ? []
}:

pkgList:

let
  wrapper = {
    extraPkgs ? [],
    extraMakeWrapperArgs ? ""
  }:
  let
    # Where we keep information about every environmental variable and the
    # separator between it's values, the default value used is `:`
    encyclopedia_of_separators = {
      # XDG_DATA_DIRS = ":";
    };
    # recursive function that goes deep through the dependency graph of a given
    # list of packages and creates a list of all buildInputs they all depend
    # on. The 2nd argument pkgsFound is used internally and it's expected to be
    # [] at the first call.
    getAllInputs = 
      pkgs:
      pkgsFound:
      map (
        pkg:
        if (builtins.typeOf pkg) == "set" then
          if builtins.hasAttr "buildInputs" pkg then
            # builtins.trace "pkg is of type ${(builtins.typeOf pkg)} and it's ${(builtins.toJSON pkg)}" (getAllInputs pkg.buildInputs pkgsFound ++ [ pkg ])
            (getAllInputs pkg.buildInputs pkgsFound ++ [ pkg ])
          else
            pkgsFound ++ [ pkg ]
        else
          # builtins.trace "pkg is not a set but a ${(builtins.typeOf pkg)} at ${(builtins.toJSON pkg)}, current pkgsFound is ${(builtins.toJSON pkgsFound)}" pkgsFound
          pkgsFound
      ) pkgs;
    # allInputs = builtins.trace "allinputs is ${builtins.toJSON (getAllInputs pkgList [])}" (getAllInputs pkgList []);
    allPkgs = (lib.lists.flatten pkgList) ++ extraPkgsByOverride ++ extraPkgs;
    allInputs = lib.lists.flatten (getAllInputs allPkgs []);
    # filter out of all the inputs the packages with the propagateEnv attribute
    envPkgs = builtins.filter (
      pkg:
      (builtins.hasAttr "propagateEnv" pkg)
    ) allInputs;
    envInfo = map (
      pkg:
      (lib.attrsets.mapAttrs (
        name:
        value:
        # TODO: make this work with other outputs as well
        builtins.replaceStrings
        [ "%out%" ]
        [ "${pkg.out}" ]
        value
      ) pkg.propagateEnv)
    ) envPkgs;
    # envInfo_ = builtins.trace "envInfo is ${(builtins.toJSON envInfo)}" envInfo;
    envInfoFolded = lib.attrsets.foldAttrs (n: a: [n] ++ a) [] envInfo;
    # envInfoFolded_ = builtins.trace "envInfoFolded is ${(builtins.toJSON envInfoFolded)}" envInfoFolded;
    # TODO: add here also this build's $out /share (e.g) to $out
    makeWrapperArgs = lib.attrsets.mapAttrsToList (
      key:
      value:
      (let 
        sep = encyclopedia_of_separators.${key} or ":";
      in 
        "--prefix ${key} ${sep} ${builtins.concatStringsSep sep value}"
      )
    ) envInfoFolded;
    makeWrapperArgs_ = builtins.trace "makeWrapperArgs is ${(builtins.toJSON makeWrapperArgs)}" makeWrapperArgs;
  in
  symlinkJoin {
    name = "runtime-env";
    paths = pkgList;

    buildInputs = [ jq makeWrapper ];
    postBuild = ''
      for i in $out/bin/*; do
        wrapProgram "$i" ${(builtins.concatStringsSep " " makeWrapperArgs_)}
      done
    '';
  };
in
  lib.makeOverridable wrapper
