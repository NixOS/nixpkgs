{ lib
, symlinkJoin
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
    # Where we keep general knowledge about known to be used environmental variables
    encyclopedia = {
      # Here we write the separator string between values of every env var, the
      # default is ":"
      separators = {
        # XDG_DATA_DIRS = ":";
      };
      # If we want the wrapping to also include an environmental variable in
      # out, we list here for every env var what path to add to the wrapper's
      # args.  You can put a list as a value as well.
      wrapOut = {
        XDG_DATA_DIRS = "$out/share";
      };
      # If you want an environment variable have a single value and that's it,
      # put it here:
      singleValue = [
        "GDK_PIXBUF_MODULE_FILE"
      ];
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
          if builtins.hasAttr "buildInputs" pkg || builtins.hasAttr "propagatedBuildInputs" pkg then
            # builtins.trace "pkg is of type ${builtins.typeOf pkg} and it's ${builtins.toJSON pkg}, with inputs: ${builtins.toJSON (pkg.buildInputs ++ pkg.propagatedBuildInputs)}" (getAllInputs (pkg.buildInputs ++ pkg.propagatedBuildInputs) (pkgsFound ++ [ pkg ]))
            (getAllInputs (pkg.buildInputs ++ pkg.propagatedBuildInputs) (pkgsFound ++ [ pkg ]))
          else
            pkgsFound ++ [ pkg ]
        else
          # builtins.trace "pkg is not a set but a ${builtins.typeOf pkg} at ${builtins.toJSON pkg}, current pkgsFound is ${builtins.toJSON pkgsFound}" pkgsFound
          pkgsFound
      ) pkgs;
    allPkgs = (lib.lists.flatten pkgList) ++ extraPkgsByOverride ++ extraPkgs;
    allInputs = lib.lists.unique (lib.lists.flatten (getAllInputs allPkgs []));
    # allInputs_ = builtins.trace "${builtins.toJSON allInputs}" allInputs;
    # filter out of all the inputs the packages with the propagateEnv attribute
    envPkgs = builtins.filter (
      pkg:
      (builtins.hasAttr "propagateEnv" pkg)
    ) allInputs;
    # Given a package, it's outputs and an envStr such as found in the values
    # of passthru's `propagateEnv`, it replaces all occurences of %<outname>%
    # from envStr according to the pkg.outputs
    replaceAllOutputs = {
      pkg,
      envStr,
      outputs,
      outname ? "out",
    }:
      let
        outname = builtins.elemAt outputs 0;
      in
      if (builtins.length outputs) == 0 then
        envStr
      else
        replaceAllOutputs {
          inherit pkg;
          outputs = lib.lists.subtractLists [outname] outputs;
          envStr = builtins.replaceStrings
            [ "@${outname}@" ]
            [ "${pkg.${outname}}" ]
          envStr;
        }
    ;
    envInfo = map (
      pkg:
      (lib.attrsets.mapAttrs (
        name:
        value:
        replaceAllOutputs {
          inherit pkg;
          outputs = pkg.outputs;
          envStr = value;
        }
      ) pkg.propagateEnv)
    ) envPkgs;
    # envInfo_ = builtins.trace "envInfo is ${(builtins.toJSON envInfo)}" envInfo;
    envInfoFolded = lib.attrsets.foldAttrs (n: a: [n] ++ a) [] envInfo;
    # envInfoFolded_ = builtins.trace "envInfoFolded is ${(builtins.toJSON envInfoFolded)}" envInfoFolded;
    # Where we add stuff according to encyclopedia.wrapOut
    envInfoWithLocal = lib.attrsets.mapAttrs (
      name:
      values:
      if builtins.hasAttr name encyclopedia.wrapOut then
        values ++ (lib.lists.flatten encyclopedia.wrapOut.${name})
      else
        values
    ) envInfoFolded;
    # envInfoWithLocal_ = builtins.trace "envInfoWithLocal is ${(builtins.toJSON envInfoWithLocal)}" envInfoWithLocal;
    makeWrapperArgs = lib.attrsets.mapAttrsToList (
      key:
      value:
      (let
        # TODO: make sure this works with any separator according to encyclopedia.separators
        sep = encyclopedia.separators.${key} or ":"; # default separator used for most wrappings
      in
        if builtins.elem key encyclopedia.singleValue then
          if (builtins.length value) > 1 then
            abort "neowrap.nix: there are two derivations in all of the \
            inputs of: ${builtins.toJSON allPkgs} that set ${key} to a value via a passthru, this \
            needs to be fixed via the passthrus of the derivations from this list: ${builtins.toJSON envPkgs}"
          else
            # Should this be "--set" ?
            "--set-default ${key} ${builtins.elemAt value 0}"
        else
          "--prefix ${key} ${sep} ${builtins.concatStringsSep sep value}"
      )
    ) envInfoWithLocal;
    # makeWrapperArgs_ = builtins.trace "makeWrapperArgs is ${(builtins.toJSON makeWrapperArgs)}" makeWrapperArgs;
  in
  symlinkJoin {
    name = "runtime-env";
    paths = pkgList;
    passthru.unwrapped = pkgList;

    buildInputs = [ makeWrapper ];
    postBuild = ''
      for i in $out/bin/*; do
        wrapProgram "$i" ${(builtins.concatStringsSep " " makeWrapperArgs)}
      done
    '';
  };
in
  lib.makeOverridable wrapper
