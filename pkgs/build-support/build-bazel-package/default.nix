{ stdenv, bazel, enableNixHacks ? true }:

args@{ name, bazelFlags ? [], bazelTarget, buildAttrs, fetchAttrs, ... }:

let
  fArgs = removeAttrs args [ "buildAttrs" "fetchAttrs" ];
  fBuildAttrs = fArgs // buildAttrs;
  fFetchAttrs = fArgs // removeAttrs fetchAttrs [ "sha256" ];

in stdenv.mkDerivation (fBuildAttrs // {
  inherit name bazelFlags bazelTarget;

  deps = stdenv.mkDerivation (fFetchAttrs // {
    name = "${name}-deps";
    inherit bazelFlags bazelTarget;

    nativeBuildInputs = fFetchAttrs.nativeBuildInputs or [] ++ [ bazel ];

    preHook = fFetchAttrs.preHook or "" + ''
      export bazelOut="$(echo ''${NIX_BUILD_TOP}/output | sed -e 's,//,/,g')"
      export bazelUserRoot="$(echo ''${NIX_BUILD_TOP}/tmp | sed -e 's,//,/,g')"
      export HOME="$NIX_BUILD_TOP"
    '';

    buildPhase = fFetchAttrs.buildPhase or ''
      runHook preBuild

      bazel --output_base="$bazelOut" --output_user_root="$bazelUserRoot" fetch $bazelFlags $bazelTarget

      runHook postBuild
    '';

    installPhase = fFetchAttrs.installPhase or ''
      runHook preInstall

      # Patching markers to make them deterministic
      for i in $bazelOut/external/\@*.marker; do
        sed -i 's, -\?[0-9][0-9]*$, 1,' "$i"
      done
      # Patching symlinks to remove build directory reference
      find $bazelOut/external -type l | while read symlink; do
        ln -sf $(readlink "$symlink" | sed "s,$NIX_BUILD_TOP,NIX_BUILD_TOP,") "$symlink"
      done

      cp -r $bazelOut/external $out

      runHook postInstall
    '';

    dontFixup = true;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = fetchAttrs.sha256;
  });

  nativeBuildInputs = fBuildAttrs.nativeBuildInputs or [] ++ [ (if enableNixHacks then (bazel.override { enableNixHacks = true; }) else bazel) ];

  preHook = fBuildAttrs.preHook or "" + ''
    export bazelOut="$NIX_BUILD_TOP/output"
    export bazelUserRoot="$NIX_BUILD_TOP/tmp"
    export HOME="$NIX_BUILD_TOP"
  '';

  preConfigure = ''
    mkdir -p $bazelOut/external
    cp -r $deps/* $bazelOut/external
    chmod -R +w $bazelOut
    find $bazelOut -type l | while read symlink; do
      ln -sf $(readlink "$symlink" | sed "s,NIX_BUILD_TOP,$NIX_BUILD_TOP,") "$symlink"
    done
  '' + fBuildAttrs.preConfigure or "";

  buildPhase = fBuildAttrs.buildPhase or ''
    runHook preBuild

    bazel --output_base="$bazelOut" --output_user_root="$bazelUserRoot" build -j $NIX_BUILD_CORES $bazelFlags $bazelTarget

    runHook postBuild
  '';
})
