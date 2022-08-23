{ stdenv
, bazel
, cacert
, lib
}:

let
  bazelPkg = bazel;
in

args@{
  name ? "${args.pname}-${args.version}"
, bazel ? bazelPkg
, bazelFlags ? []
, bazelBuildFlags ? []
, bazelFetchFlags ? []
, bazelTarget
, buildAttrs
, fetchAttrs

# Newer versions of Bazel are moving away from built-in rules_cc and instead
# allow fetching it as an external dependency in a WORKSPACE file[1]. If
# removed in the fixed-output fetch phase, building will fail to download it.
# This can be seen e.g. in #73097
#
# This option allows configuring the removal of rules_cc in cases where a
# project depends on it via an external dependency.
#
# [1]: https://github.com/bazelbuild/rules_cc
, removeRulesCC ? true
, removeLocalConfigCc ? true
, removeLocal ? true

# Use build --nobuild instead of fetch. This allows fetching the dependencies
# required for the build as configured, rather than fetching all the dependencies
# which may not work in some situations (e.g. Java code which ends up relying on
# Debian-specific /usr/share/java paths, but doesn't in the configured build).
, fetchConfigured ? true

# Don’t add Bazel --copt and --linkopt from NIX_CFLAGS_COMPILE /
# NIX_LDFLAGS. This is necessary when using a custom toolchain which
# Bazel wants all headers / libraries to come from, like when using
# CROSSTOOL. Weirdly, we can still get the flags through the wrapped
# compiler.
, dontAddBazelOpts ? false
, ...
}:

let
  fArgs = removeAttrs args [ "buildAttrs" "fetchAttrs" "removeRulesCC" ];
  fBuildAttrs = fArgs // buildAttrs;
  fFetchAttrs = fArgs // removeAttrs fetchAttrs [ "sha256" ];

in stdenv.mkDerivation (fBuildAttrs // {
  inherit name bazelFlags bazelBuildFlags bazelFetchFlags bazelTarget;

  deps = stdenv.mkDerivation (fFetchAttrs // {
    name = "${name}-deps.tar.gz";
    inherit bazelFlags bazelBuildFlags bazelFetchFlags bazelTarget;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ fFetchAttrs.impureEnvVars or [];

    nativeBuildInputs = fFetchAttrs.nativeBuildInputs or [] ++ [ bazel ];

    preHook = fFetchAttrs.preHook or "" + ''
      export bazelOut="$(echo ''${NIX_BUILD_TOP}/output | sed -e 's,//,/,g')"
      export bazelUserRoot="$(echo ''${NIX_BUILD_TOP}/tmp | sed -e 's,//,/,g')"
      export HOME="$NIX_BUILD_TOP"
      export USER="nix"
      # This is needed for git_repository with https remotes
      export GIT_SSL_CAINFO="${cacert}/etc/ssl/certs/ca-bundle.crt"
      # This is needed for Bazel fetchers that are themselves programs (e.g.
      # rules_go using the go toolchain)
      export SSL_CERT_FILE="${cacert}/etc/ssl/certs/ca-bundle.crt"
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
        ${if fetchConfigured then "build --nobuild" else "fetch"} \
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
      ${if removeRulesCC then "rm -rf $bazelOut/external/{rules_cc,\\@rules_cc.marker}" else ""}
      rm -rf $bazelOut/external/{embedded_jdk,\@embedded_jdk.marker}
      ${if removeLocalConfigCc then "rm -rf $bazelOut/external/{local_config_cc,\\@local_config_cc.marker}" else ""}
      ${if removeLocal then "rm -rf $bazelOut/external/{local_*,\\@local_*.marker}" else ""}

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
        rm "$symlink"
        test -f "$bazelOut/external/@$name.marker" && rm "$bazelOut/external/@$name.marker" || true
      done

      # Patching symlinks to remove build directory reference
      find $bazelOut/external -type l | while read symlink; do
        new_target="$(readlink "$symlink" | sed "s,$NIX_BUILD_TOP,NIX_BUILD_TOP,")"
        rm "$symlink"
        ln -sf "$new_target" "$symlink"
      done

      echo '${bazel.name}' > $bazelOut/external/.nix-bazel-version

      (cd $bazelOut/ && tar czf $out --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner external/)

      runHook postInstall
    '';

    dontFixup = true;
    allowedRequisites = [];

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

    (cd $bazelOut && tar xfz $deps)

    test "${bazel.name}" = "$(<$bazelOut/external/.nix-bazel-version)" || {
      echo "fixed output derivation was built for a different bazel version" >&2
      echo "     got: $(<$bazelOut/external/.nix-bazel-version)" >&2
      echo "expected: ${bazel.name}" >&2
      exit 1
    }

    chmod -R +w $bazelOut
    find $bazelOut -type l | while read symlink; do
      if [[ $(readlink "$symlink") == *NIX_BUILD_TOP* ]]; then
        ln -sf $(readlink "$symlink" | sed "s,NIX_BUILD_TOP,$NIX_BUILD_TOP,") "$symlink"
      fi
    done
  '' + fBuildAttrs.preConfigure or "";

  inherit dontAddBazelOpts;

  buildPhase = fBuildAttrs.buildPhase or ''
    runHook preBuild

    # Bazel sandboxes the execution of the tools it invokes, so even though we are
    # calling the correct nix wrappers, the values of the environment variables
    # the wrappers are expecting will not be set. So instead of relying on the
    # wrappers picking them up, pass them in explicitly via `--copt`, `--linkopt`
    # and related flags.
    #
    copts=()
    host_copts=()
    linkopts=()
    host_linkopts=()
    if [ -z "''${dontAddBazelOpts:-}" ]; then
      for flag in $NIX_CFLAGS_COMPILE; do
        copts+=( "--copt=$flag" )
        host_copts+=( "--host_copt=$flag" )
      done
      for flag in $NIX_CXXSTDLIB_COMPILE; do
        copts+=( "--copt=$flag" )
        host_copts+=( "--host_copt=$flag" )
      done
      for flag in $NIX_LDFLAGS; do
        linkopts+=( "--linkopt=-Wl,$flag" )
        host_linkopts+=( "--host_linkopt=-Wl,$flag" )
      done
    fi

    BAZEL_USE_CPP_ONLY_TOOLCHAIN=1 \
    USER=homeless-shelter \
    bazel \
      --output_base="$bazelOut" \
      --output_user_root="$bazelUserRoot" \
      build \
      --curses=no \
      -j $NIX_BUILD_CORES \
      "''${copts[@]}" \
      "''${host_copts[@]}" \
      "''${linkopts[@]}" \
      "''${host_linkopts[@]}" \
      $bazelFlags \
      $bazelBuildFlags \
      $bazelTarget

    runHook postBuild
  '';
})
