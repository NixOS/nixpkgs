# The wrapper script ensures variables like PKG_CONFIG_PATH and
# PKG_CONFIG_PATH_FOR_BUILD work properly.

{ stdenvNoCC
, buildPackages
, pkg-config
, propagateDoc ? pkg-config != null && pkg-config ? man
, extraPackages ? [], extraBuildCommands ? ""
}:

with stdenvNoCC.lib;

let
  stdenv = stdenvNoCC;
  inherit (stdenv) hostPlatform targetPlatform;

  # Prefix for binaries. Customarily ends with a dash separator.
  #
  # TODO(@Ericson2314) Make unconditional, or optional but always true by
  # default.
  targetPrefix = stdenv.lib.optionalString (targetPlatform != hostPlatform)
                                        (targetPlatform.config + "-");

  # See description in cc-wrapper.
  suffixSalt = replaceStrings ["-" "."] ["_" "_"] targetPlatform.config;

in

stdenv.mkDerivation {
  pname = targetPrefix + pkg-config.pname + "-wrapper";
  inherit (pkg-config) version;

  preferLocalBuild = true;

  shell = getBin stdenvNoCC.shell + stdenvNoCC.shell.shellPath or "";

  inherit targetPrefix suffixSalt;

  outputs = [ "out" ] ++ optionals propagateDoc [ "man" ];

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

      wrap ${targetPrefix}pkg-config ${./pkg-config-wrapper.sh} "${getBin pkg-config}/bin/pkg-config"
    '';

  strictDeps = true;

  wrapperName = "PKG_CONFIG_WRAPPER";

  setupHooks = [
    ../setup-hooks/role.bash
    ./setup-hook.sh
  ];

  postFixup =
    ''

      ##
      ## User env support
      ##

      # Propagate the underling unwrapped pkg-config so that if you
      # install the wrapper, you get anything else it might provide.
      printWords ${pkg-config} > $out/nix-support/propagated-user-env-packages
    ''

    + optionalString propagateDoc ''
      ##
      ## Man page and info support
      ##

      ln -s ${pkg-config.man} $man
    ''

    + ''
      substituteAll ${./add-flags.sh} $out/nix-support/add-flags.sh
      substituteAll ${../wrapper-common/utils.bash} $out/nix-support/utils.bash

      ##
      ## Extra custom steps
      ##
    ''

    + extraBuildCommands;

  meta =
    let pkg-config_ = if pkg-config != null then pkg-config else {}; in
    (if pkg-config_ ? meta then removeAttrs pkg-config.meta ["priority"] else {}) //
    { description =
        stdenv.lib.attrByPath ["meta" "description"] "pkg-config" pkg-config_
        + " (wrapper script)";
      priority = 10;
  };
}
