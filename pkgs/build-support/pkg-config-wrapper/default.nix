# The wrapper script ensures variables like PKG_CONFIG_PATH and
# PKG_CONFIG_PATH_FOR_BUILD work properly.

{ stdenvNoCC
, lib
, buildPackages
, pkg-config
, baseBinName ? "pkg-config"
, propagateDoc ? pkg-config != null && pkg-config ? man
, extraPackages ? [], extraBuildCommands ? ""
}:

with lib;

let
  stdenv = stdenvNoCC;
  inherit (stdenv) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = lib.optionalString (targetPlatform != hostPlatform)
                                        (targetPlatform.config + "-");

  # See description in cc-wrapper.
  suffixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

in

stdenv.mkDerivation {
  pname = targetPrefix + pkg-config.pname + "-wrapper";
  inherit (pkg-config) version;

  preferLocalBuild = true;

  shell = getBin stdenvNoCC.shell + stdenvNoCC.shell.shellPath or "";

  inherit targetPrefix suffixSalt baseBinName;

  outputs = [ "out" ] ++ optionals propagateDoc ([ "man" ] ++ optional (pkg-config ? doc) "doc");

  passthru = {
    inherit pkg-config;
  };

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    src=$PWD
  '';

  installPhase =
    ''
      mkdir -p $out/bin $out/nix-support

      wrap() {
        local dst="$1"
        local wrapper="$2"
        export prog="$3"
        substituteAll "$wrapper" "$out/bin/$dst"
        chmod +x "$out/bin/$dst"
      }

      echo $pkg-config > $out/nix-support/orig-pkg-config

      wrap ${targetPrefix}${baseBinName} ${./pkg-config-wrapper.sh} "${getBin pkg-config}/bin/${baseBinName}"
    ''
    # symlink in share for autoconf to find macros

    # TODO(@Ericson2314): in the future just make the unwrapped pkg-config a
    # propagated dep once we can rely on downstream deps comming first in
    # search paths. (https://github.com/NixOS/nixpkgs/pull/31414 took a crack
    # at this.)
    + ''
      ln -s ${pkg-config}/share $out/share
    '';

  strictDeps = true;

  wrapperName = "PKG_CONFIG_WRAPPER";

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
    + optionalString propagateDoc (''
      ln -s ${pkg-config.man} $man
    '' + optionalString (pkg-config ? doc) ''
      ln -s ${pkg-config.doc} $doc
    '')

    + ''
      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${../wrapper-common/utils.bash} $out/nix-support/utils.bash
    ''

    ##
    ## Extra custom steps
    ##
    + extraBuildCommands;

  meta =
    let pkg-config_ = if pkg-config != null then pkg-config else {}; in
    (if pkg-config_ ? meta then removeAttrs pkg-config.meta ["priority"] else {}) //
    { description =
        lib.attrByPath ["meta" "description"] "pkg-config" pkg-config_
        + " (wrapper script)";
      priority = 10;
  };
}
