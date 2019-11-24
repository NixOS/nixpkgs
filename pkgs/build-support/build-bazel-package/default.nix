{ stdenv
, bazel
, cacert
, lib
}:

args@{ name, bazelFlags ? [], bazelBuildFlags ? [], bazelFetchFlags ? [], bazelTarget, buildAttrs, fetchAttrs, ... }:

let
  fArgs = removeAttrs args [ "buildAttrs" "fetchAttrs" ];
  fBuildAttrs = fArgs // buildAttrs;
  fFetchAttrs = fArgs // removeAttrs fetchAttrs [ "sha256" ];

in stdenv.mkDerivation (fBuildAttrs // {
  inherit name bazelFlags bazelBuildFlags bazelFetchFlags bazelTarget;

  deps = stdenv.mkDerivation (fFetchAttrs // {
    name = "${name}-deps";
    inherit bazelFlags bazelBuildFlags bazelFetchFlags bazelTarget;

    nativeBuildInputs = fFetchAttrs.nativeBuildInputs or [] ++ [ bazel ];

    preHook = fFetchAttrs.preHook or "" + ''
      export bazelOut="$(echo ''${NIX_BUILD_TOP}/output | sed -e 's,//,/,g')"
      export bazelUserRoot="$(echo ''${NIX_BUILD_TOP}/tmp | sed -e 's,//,/,g')"
      export HOME="$NIX_BUILD_TOP"
      # This is needed for git_repository with https remotes
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
    '';

    buildPhase = fFetchAttrs.buildPhase or ''
      runHook preBuild

      # Bazel computes the default value of output_user_root before parsing the
      # flag. The computation of the default value involves getting the $USER
      # from the environment. I don't have that variable when building with
      # sandbox enabled. Code here
      # https://github.com/bazelbuild/bazel/blob/9323c57607d37f9c949b60e293b573584906da46/src/main/cpp/startup_options.cc#L123-L124
      #
      # On macOS Bazel will use the system installed Xcode or CLT toolchain instead of the one in the PATH unless we pass BAZEL_USE_CPP_ONLY_TOOLCHAIN

      # We disable multithreading for the fetching phase since it can lead to timeouts with many dependencies/threads:
      # https://github.com/bazelbuild/bazel/issues/6502
      BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 \
      USER=homeless-shelter \
      bazel \
        --output_base="$bazelOut" \
        --output_user_root="$bazelUserRoot" \
        fetch \
        --loading_phase_threads=1 \
        $bazelFlags \
        $bazelFetchFlags \
        $bazelTarget

      runHook postBuild
    '';

    installPhase = fFetchAttrs.installPhase or ''
      runHook preInstall

      # Remove all built in external workspaces, Bazel will recreate them when building
      rm -rf $bazelOut/external/{bazel_tools,\@bazel_tools.marker}
      rm -rf $bazelOut/external/{rules_cc,\@rules_cc.marker}
      rm -rf $bazelOut/external/{embedded_jdk,\@embedded_jdk.marker}
      rm -rf $bazelOut/external/{local_*,\@local_*.marker}

      # Clear markers
      find $bazelOut/external -name '@*\.marker' -exec sh -c 'echo > {}' \;

      # Remove all vcs files
      rm -rf $(find $bazelOut/external -type d -name .git)
      rm -rf $(find $bazelOut/external -type d -name .svn)
      rm -rf $(find $bazelOut/external -type d -name .hg)

      # Removing top-level symlinks along with their markers.
      # This is needed because they sometimes point to temporary paths (?).
      # For example, in Tensorflow-gpu build:
      # platforms -> NIX_BUILD_TOP/tmp/install/35282f5123611afa742331368e9ae529/_embedded_binaries/platforms
      find $bazelOut/external -maxdepth 1 -type l | while read symlink; do
        name="$(basename "$symlink")"
        rm "$symlink" "$bazelOut/external/@$name.marker"
      done

      # Patching symlinks to remove build directory reference
      find $bazelOut/external -type l | while read symlink; do
        new_target="$(readlink "$symlink" | sed "s,$NIX_BUILD_TOP,NIX_BUILD_TOP,")"
        rm "$symlink"
        ln -sf "$new_target" "$symlink"
      done

      cp -r $bazelOut/external $out

      runHook postInstall
    '';

    dontFixup = true;
    allowedRequisites = [];

    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = fetchAttrs.sha256;
  });

  nativeBuildInputs = fBuildAttrs.nativeBuildInputs or [] ++ [ (bazel.override { enableNixHacks = true; }) ];

  preHook = fBuildAttrs.preHook or "" + ''
    export bazelOut="$NIX_BUILD_TOP/output"
    export bazelUserRoot="$NIX_BUILD_TOP/tmp"
    export HOME="$NIX_BUILD_TOP"
  '';

  preConfigure = ''
    mkdir -p "$bazelOut"
    cp -r $deps $bazelOut/external
    chmod -R +w $bazelOut
    find $bazelOut -type l | while read symlink; do
      ln -sf $(readlink "$symlink" | sed "s,NIX_BUILD_TOP,$NIX_BUILD_TOP,") "$symlink"
    done
  '' + fBuildAttrs.preConfigure or "";

  buildPhase = fBuildAttrs.buildPhase or ''
    runHook preBuild

    '' + lib.optionalString stdenv.isDarwin ''
    # Bazel sandboxes the execution of the tools it invokes, so even though we are
    # calling the correct nix wrappers, the values of the environment variables
    # the wrappers are expecting will not be set. So instead of relying on the
    # wrappers picking them up, pass them in explicitly via `--copt`, `--linkopt`
    # and related flags.
    #
    copts=()
    host_copts=()
    for flag in $NIX_CFLAGS_COMPILE; do
      copts+=( "--copt=$flag" )
      host_copts+=( "--host_copt=$flag" )
    done
    for flag in $NIX_CXXSTDLIB_COMPILE; do
      copts+=( "--copt=$flag" )
      host_copts+=( "--host_copt=$flag" )
    done
    linkopts=()
    host_linkopts=()
    for flag in $NIX_LD_FLAGS; do
      linkopts+=( "--linkopt=$flag" )
      host_linkopts+=( "--host_linkopt=$flag" )
    done
    '' + ''

    BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 \
    USER=homeless-shelter \
    bazel \
      --output_base="$bazelOut" \
      --output_user_root="$bazelUserRoot" \
      build \
      -j $NIX_BUILD_CORES \
      '' + lib.optionalString stdenv.isDarwin ''
      "''${copts[@]}" \
      "''${host_copts[@]}" \
      "''${linkopts[@]}" \
      "''${host_linkopts[@]}" \
      '' + ''
      $bazelFlags \
      $bazelBuildFlags \
      $bazelTarget

    runHook postBuild
  '';
})
