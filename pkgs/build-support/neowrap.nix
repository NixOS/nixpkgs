{ lib
, symlinkJoin
, makeWrapper
, lndir
, pkgs
, extraPkgsByOverride ? []
}:

# A single pkg or a list of pkgs mainly packaged
pkgList:

let
  wrapper = {
    extraPkgs ? [],
    extraMakeWrapperArgs ? "",
    # An attribute set that tells the builder how to handle links per file /
    # directory found in every key of propagateEnv. E.g:
    /*** example value ***
    linkByEnv = {
      # Tells the builder to link the files in every directory that propagates
      # XDG_DATA_DIRS.
      XDG_DATA_DIRS = "link";
      # Tells the builder to simply link all the files of a package that
      # propagets this env var. Note that this may affect closure size of the
      # result as every pkg's all outputs are used unconditionally. Useful for
      # python / other languages wrappings
      GI_TYPELIB_PATH = "linkPkg";
    },
    */
    # TODO: Decide what to do when `linkPkg` is used here and the file
    # nix-support/propagated-build-inputs has different values per package
    linkByEnv ? {},
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
      # values.
      wrapOut = {
        XDG_DATA_DIRS = "$out/share";
      };
      # If the `link` argument was supplied, we use the keys provided here as a
      # dictionary that defines where to symlink the files that the caller
      # wants to be symlinked as well, per env var. If a key shows up here and
      # in wrapOut as well, it is expected they will have the same value.
      linkPaths = {
        XDG_DATA_DIRS = "$out/share";
        GI_TYPELIB_PATH = "$out/lib/girepository-1.0";
        QT_PLUGIN_PATH = "$out/${pkgs.qt5.qtbase.qtPluginPrefix}";
        QML2_IMPORT_PATH = "$out/${pkgs.qt5.qtbase.qtQmlPrefix}";
      };
      # If you want an environment variable to have a single value and that's it,
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
    # allInputs_ = builtins.trace "allInputs is: ${builtins.toJSON allInputs}" allInputs;
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
    # Where we calculate every env var's values. This also considers the `link`
    # argument's value - if it was requested to `link` directories of certain
    # env vars or paths, that's taken care of later, at `linkInfo`. The
    # encyclopedia's `linkPaths` set is used if needed.
    # envInfo = map (
    envInfo = lib.attrsets.foldAttrs (n: a: lib.lists.unique ([n] ++ a)) [] (map (
      pkg:
      # for every package in envPkgs, do the following for every env key and value
      (lib.attrsets.mapAttrs (
        # env var name
        name:
        # env var value
        value:
        let
          real_value = replaceAllOutputs {
            inherit pkg;
            outputs = pkg.outputs;
            envStr = value;
          };
        in
          if builtins.hasAttr name linkByEnv then
            if builtins.hasAttr name encyclopedia.linkPaths then
              if linkByEnv.${name} == "link" then
                {
                  linkType = "normal";
                  linkTo = encyclopedia.linkPaths.${name};
                  linkFrom = real_value;
                }
              else # linkByEnv.${name} == "linkPkg"
                {
                  linkType = "pkg";
                  linkTo = "$out";
                  linkFrom = pkg;
                }
            else
              abort "neowrap.nix: I was requested to symlink paths of propagated environment for env var `${name}` but I don't know where to put these files as they are not in my encyclopedia"
          else
            real_value
      ) pkg.propagateEnv)
    ) envPkgs);
    # ) envPkgs;
    envInfo_ = builtins.trace "envInfo is ${(builtins.toJSON envInfo)}" envInfo;
    makeWrapperArgs = lib.lists.flatten (lib.attrsets.mapAttrsToList (
      key:
      value:
      (let
        sep = encyclopedia.separators.${key} or ":"; # default separator used for most wrappings
      in
        # To filter out envInfo changed via the `linkByEnv` argument
        if builtins.isString (builtins.elemAt value 0) then
          if builtins.elem key encyclopedia.singleValue then
            if (builtins.length value) > 1 then
              abort "neowrap.nix: There is more then 1 derivation in all inputs of: ${builtins.toJSON allPkgs} that set ${key} to a value via a passthru. This env key, is defined in my encyclopedia as a single value key. Hence I don't know what value to use in wrapping."
            else
              # Should this be "--set" ?
              "--set-default ${key} ${builtins.elemAt value 0}"
          else
            "--prefix ${key} ${sep} ${builtins.concatStringsSep sep value}"
        else
          # duplicates are removed by lib.lists.flatten at the beginning
          if (builtins.elemAt value 0).linkType == "normal" then
            "--prefix ${key} ${sep} ${(builtins.elemAt value 0).linkTo}"
          else # (builtins.elemAt value 0).linkType == "pkg" then
            "--prefix ${key} ${sep} ${encyclopedia.linkPaths.${key}}"
      )
    )
      # Before calculating makeWrapperArgs, we need to add values to env vars
      # according to encyclopedia.wrapOut:
      (lib.attrsets.mapAttrs (
        name:
        values:
        if builtins.hasAttr name encyclopedia.wrapOut && builtins.isList values then
          if builtins.elem encyclopedia.wrapOut.${name} values then
            values
          else
            values ++ [encyclopedia.wrapOut.${name}]
        else
          values
      ) envInfo)
    );
    makeWrapperArgs_ = builtins.trace "makeWrapperArgs is ${builtins.toJSON makeWrapperArgs}" makeWrapperArgs;
    linkCmds = lib.lists.flatten (lib.attrsets.mapAttrsToList (
      key:
      values:
      (let
        sep = encyclopedia.separators.${key} or ":"; # default separator used for most wrappings
      in
        if builtins.isAttrs (builtins.elemAt values 0) then
          (map (
            v:
            "mkdir -p ${v.linkTo} && lndir -silent ${v.linkFrom} ${v.linkTo}"
          ) values)
        else
          # removed by lib.lists.flatten at the beginning
          []
      )
    )
      envInfo
    );
    linkCmds_ = builtins.trace "linkCmds is ${builtins.toJSON linkCmds}" linkCmds;
  in
  symlinkJoin {
    name = "runtime-env";
    paths = pkgList;
    passthru.unwrapped = pkgList;

    buildInputs = [ makeWrapper lndir ];
    postBuild = ''
      ${builtins.concatStringsSep "\n" linkCmds_}
      for i in $out/bin/*; do
        wrapProgram "$i" ${builtins.concatStringsSep " " makeWrapperArgs_}
      done
    '';
  };
in
  lib.makeOverridable wrapper
