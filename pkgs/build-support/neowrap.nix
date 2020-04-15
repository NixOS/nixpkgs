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
    /*** Another example value ***
    linkByEnv ? {
      QT_PLUGIN_PATH = "link";
      QML2_IMPORT_PATH = "link";
    },
    */
    # TODO: Decide what to do when `linkPkg` is used here and the file
    # nix-support/propagated-build-inputs has different values per package
    linkByEnv ? {},
    # If we want the wrapping to also include an environmental variable in
    # out, we list here for every env var what path to add to the wrapper's
    # values.
    /*** example value ***
    wrapOut ? {
      XDG_DATA_DIRS = "$out/share";
      PYTHONPATH = "$out/${pkgs.python3.sitePackages}";
    },
    */
    wrapOut ? {},
  }:
  let
    # Where we keep general knowledge about known to be used environmental variables
    encyclopedia = {
      # Here we write the separator string between values of every env var, the
      # default is ":"
      separators = {
        # XDG_DATA_DIRS = ":";
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
        # Not using a strict version here as it may confuse someone digging
        # into the results of this wrapper
        PYTHONPATH = "$out/python-sitePackages";
      };
      # If you want an environment variable to have a single value and that's it,
      # put it here:
      singleValue = [
        "GDK_PIXBUF_MODULE_FILE"
      ];
      # To prevent a stack overflow when inspecting a derivation's inputs
      # recursively, we use this list to tell the function that dives into the
      # dependency graph, what packages should be skipped instantly.
      skipDivingInto = with pkgs; [
        gnu-efi iptables kexectools libapparmor libcap libidn2 libmicrohttpd
        libnetfilter_conntrack libnftnl libseccomp pciutils systemd acl autogen
        gnutls guile libevent p11-kit unbound xorg.libXext freetype xorg.libICE
        libpng_apng kmod libgcrypt curl libkrb5 libssh2 nghttp2 libtool nettle
        glib libselinux utillinux xorg.libX11 xorg.libxcb xorg.libXdmcp libxslt cracklib
        linux-pam xorg.libXau libxml2 sqlite readline bison zlib libffi openssl ncurses
        # Note we add perl itself here, not any library of it
        perl xorg.xorgproto expat xz fontconfig xorg.libXfixes llvm
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
        if builtins.isAttrs pkg then
          let
            inEncyclopedia =
              inputPkg:
              lib.lists.any (
                knownPkg:
                if builtins.isAttrs inputPkg then
                  # builtins.trace "testing ${inputPkg.name} if in encyclopedia: ${builtins.toJSON (inputPkg.name == knownPkg.name)}" inputPkg.name == knownPkg.name
                  inputPkg.name == knownPkg.name
                else
                  false
                ) encyclopedia.skipDivingInto
            ;
            notInEncyclopedia = 
              inputPkg:
              !(inEncyclopedia inputPkg)
            ;
            hasInputs = pkg.buildInputs != [] || pkg.propagatedBuildInputs != [];
          in
            if !(inEncyclopedia pkg) && hasInputs then
              let
                # From some reason, pkg == knownPkg doesn't work :/ don't know
                # why... Never the less this should be good enough
                deeperPkgs = builtins.filter notInEncyclopedia (pkg.buildInputs ++ pkg.propagatedBuildInputs);
                deeperPkgs_ = builtins.trace "deeper is ${builtins.toJSON deeperPkgs}" deeperPkgs;
                currentPkgs = pkgsFound ++ pkgs;
              in
                (getAllInputs deeperPkgs currentPkgs)
            else
              pkgsFound ++ [ pkg ]
        else
          []
      ) pkgs
    ;
    allPkgs = (lib.lists.flatten pkgList) ++ extraPkgsByOverride ++ extraPkgs;
    # Useful for debugging, not evaluated if not used.
    allPkgs_ = builtins.trace "allPkgs is: ${builtins.toJSON allPkgs}" allPkgs;
    allInputs = lib.lists.unique (lib.lists.flatten (getAllInputs allPkgs []));
    # Useful for debugging, not evaluated if not used.
    allInputs_ = builtins.trace "allInputs is: ${builtins.toJSON allInputs}" allInputs;
    # filter out of all the inputs the packages with the propagateEnv attribute
    envPkgs = builtins.filter (
      pkg:
      if builtins.isAttrs pkg then
        (builtins.hasAttr "propagateEnv" pkg)
      else
        false
    ) allInputs;
    # Useful for debugging, not evaluated if not used.
    envPkgs_ = builtins.trace "envPkgs is: ${builtins.toJSON envPkgs}" envPkgs;
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
                  # Should this be `pkg.dev` or simply `pkg` ?
                  linkFrom = pkg.out;
                }
            else
              abort "neowrap.nix: I was requested to symlink paths of propagated environment for env var `${name}` but I don't know where to put these files as they are not in my encyclopedia"
          else
            real_value
      ) pkg.propagateEnv)
    ) envPkgs);
    # Useful for debugging, not evaluated if not used.
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
      # according to the `wrapOut` argument:
      (lib.attrsets.mapAttrs (
        name:
        values:
        if builtins.hasAttr name wrapOut && builtins.isList values then
          if builtins.elem wrapOut.${name} values then
            values
          else
            values ++ [wrapOut.${name}]
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
    # Useful for debugging, not evaluated if not used.
    linkCmds_ = builtins.trace "linkCmds is ${builtins.toJSON linkCmds}" linkCmds;
  in
  symlinkJoin {
    name = "runtime-env";
    paths = pkgList;
    passthru.unwrapped = pkgList;

    buildInputs = [ makeWrapper lndir ];
    postBuild = ''
      ${builtins.concatStringsSep "\n" linkCmds}
      for i in $out/bin/*; do
        wrapProgram "$i" ${builtins.concatStringsSep " " makeWrapperArgs}
      done
    '';
  };
in
  lib.makeOverridable wrapper
