{ lib
, buildEnv
, jq
}:

pkgList:

let
  wrapper = {
    extraMakeWrapperArgs ? ""
  }:
  let
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
    allInputs = lib.lists.flatten (getAllInputs pkgList []);
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
    envInfo_ = builtins.trace "envInfo is ${(builtins.toJSON envInfo)}" envInfo;
    # envInfoFolded = lib.attrsets.foldAttrs (n: a: [n] ++ a) [] envInfo;
  in
  buildEnv {
    name = "runtime-env";
    paths = pkgList;

    buildInputs = [ jq ];
    postBuild = ''
      printf '%s\n' ${builtins.concatStringsSep " " envInfo_}
      exit 1
    '';
  };
in
  lib.makeOverridable wrapper
