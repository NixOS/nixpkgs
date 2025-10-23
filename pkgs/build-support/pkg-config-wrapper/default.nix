# The wrapper script ensures variables like PKG_CONFIG_PATH and
# PKG_CONFIG_PATH_FOR_BUILD work properly.

{
  stdenvNoCC,
  lib,
  buildPackages,
  pkg-config,
  baseBinName ? "pkg-config",
  propagateDoc ? pkg-config != null && pkg-config ? man,
  extraPackages ? [ ],
  extraBuildCommands ? "",
}:

let
  inherit (lib)
    attrByPath
    getBin
    optional
    optionalAttrs
    optionals
    optionalString
    replaceStrings
    ;

  stdenv = stdenvNoCC;
  inherit (stdenv) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = optionalString (targetPlatform != hostPlatform) (targetPlatform.config + "-");

  # See description in cc-wrapper.
  suffixSalt = replaceStrings [ "-" "." ] [ "_" "_" ] targetPlatform.config;

  wrapperBinName = "${targetPrefix}${baseBinName}";
in

stdenv.mkDerivation {
  pname = targetPrefix + pkg-config.pname + "-wrapper";
  inherit (pkg-config) version;

  enableParallelBuilding = true;

  preferLocalBuild = true;

  outputs = [ "out" ] ++ optionals propagateDoc ([ "man" ] ++ optional (pkg-config ? doc) "doc");

  passthru = {
    inherit targetPrefix suffixSalt;
    inherit pkg-config;
  };

  strictDeps = true;
  dontBuild = true;
  dontConfigure = true;
  dontUnpack = true;

  # Additional flags passed to pkg-config.
  env.addFlags = optionalString stdenv.targetPlatform.isStatic "--static";

  installPhase = ''
    mkdir -p $out/bin $out/nix-support

    wrap() {
      local dst="$1"
      local wrapper="$2"
      export prog="$3"
      substituteAll "$wrapper" "$out/bin/$dst"
      chmod +x "$out/bin/$dst"
    }

    echo $pkg-config > $out/nix-support/orig-pkg-config

    wrap ${wrapperBinName} ${./pkg-config-wrapper.sh} "${getBin pkg-config}/bin/${baseBinName}"
  ''
  # symlink in share for autoconf to find macros

  # TODO(@Ericson2314): in the future just make the unwrapped pkg-config a
  # propagated dep once we can rely on downstream deps coming first in
  # search paths. (https://github.com/NixOS/nixpkgs/pull/31414 took a crack
  # at this.)
  + ''
    ln -s ${pkg-config}/share $out/share
  '';

  setupHooks = [
    ../setup-hooks/role.bash
    ./setup-hook.sh
  ];

  postFixup =
    ##
    ## User env support
    ##

    # Propagate the underling unwrapped pkg-config so that if you
    # install the wrapper, you get anything else it might provide.
    ''
      printWords ${pkg-config} > $out/nix-support/propagated-user-env-packages
    ''

    ##
    ## Man page and doc support
    ##
    + optionalString propagateDoc (
      ''
        ln -s ${pkg-config.man} $man
      ''
      + optionalString (pkg-config ? doc) ''
        ln -s ${pkg-config.doc} $doc
      ''
    )

    + ''
      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${../wrapper-common/utils.bash} $out/nix-support/utils.bash
    ''

    ##
    ## Extra custom steps
    ##
    + extraBuildCommands;

  env = {
    shell = getBin stdenvNoCC.shell + stdenvNoCC.shell.shellPath or "";
    wrapperName = "PKG_CONFIG_WRAPPER";
    inherit targetPrefix suffixSalt baseBinName;
  };

  meta =
    let
      pkg-config_ = optionalAttrs (pkg-config != null) pkg-config;
    in
    (optionalAttrs (pkg-config_ ? meta) (
      removeAttrs pkg-config.meta [
        "priority"
        "mainProgram"
      ]
    ))
    // {
      description = attrByPath [ "meta" "description" ] "pkg-config" pkg-config_ + " (wrapper script)";
      priority = 10;
      mainProgram = wrapperBinName;
    };
}
