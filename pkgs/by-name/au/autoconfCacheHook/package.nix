{
  autoconf,
  automake,
  gettext,
  gnulib,
  makeSetupHook,
  path,
  runCommand,
  shellcheck,
  stdenv,
}:
let
  fetchurlBoot = import (path + "/pkgs/build-support/fetchurl/boot.nix") {
    inherit (stdenv.buildPlatform) system;
  };

  # keep src in sync between gnulib and gnulib-bootstrap
  # TODO: should this be untied, to prevent mass rebuilds when gnulib is updated?
  gnulib-src = fetchurlBoot {
    url = gnulib.src.url;
    hash = gnulib.src.outputHash;
  };

  # the shell script variant of gnulib without python and perl dependencies
  gnulib-bootstrap = runCommand "gnulib-bootstrap" { } ''
    tar -xf ${gnulib-src} --strip-components=1
    mkdir -p $out/bin
    cp -r * $out/
    ln -s $out/lib $out/include
    ln -s $out/gnulib-tool $out/bin/
  '';

  # TODO: add more checks to ./src/configure.ac to increase the power of the cache
  cacheFileRaw = stdenv.mkDerivation {
    name = "autoconf-cache-file-raw";
    src = ./src;

    nativeBuildInputs = [
      gettext
      autoconf
      automake
      gnulib-bootstrap
    ];
    buildPhase = ''
      substituteInPlace configure.ac \
        --replace-fail __GETTEXT_VERSION__ "${gettext.version}"

      gnulib-tool --list | xargs gnulib-tool --import
      autoreconf --install --force
      ./configure --config-cache
    '';
    installPhase = ''
      mkdir $out
      mv config.cache $out/config.cache
    '';
    /*
      Wipe the cache of any entries with /nix/store references.
      This removes ~20 cache entries, but avoids bootstrapping issues in stdenv.
    */
    fixupPhase = ''
      grep -v ${builtins.storeDir} $out/config.cache > cleaned
      mv cleaned $out/config.cache
      mv configure $out/configure
    '';
  };

  # entries to be removed from the cache
  # to see the logic behind a certain variable:
  #   - build the original cache-file + configure script via `nix-build -A autoconfCacheHook.cacheFile`
  #   - search the script `./result/configure` for the variable name to find the logic
  ignoreResults = [
    /*
      Remove all cached env vars
      This prevents ./configure from rejecting the cache whenever the environment changed
      This prevents errors of this form:
        - `configure: error: 'CPP' was not set in the previous run`
        - `configure: error: 'LDFLAGS' was not set in the previous run`
    */
    "ac_cv_env_"

    /*
      strangely the following entries get different values in some derivations comparing a
        cache built from scratch inside that derivation, vs the cache built here.
      (set autoconfCacheDebug=true in a derivation to debug this if it fails building)
      TODO: figure out why the environment of the derivation building the cache is different from derivations that use it.
    */
    "ac_cv_build"
    "ac_cv_host"
    "ac_cv_target"
    "ac_cv_prog_CPP"
    "gl_cv_c_bool"
    "gl_cv_c_nullptr"
    "gl_cv_func_unreachable"
    "gl_cv_static_assert"
    "gl_cv_header_working_stdalign_h"
    # prevents ac_cv_prog_CPP: ${ac_cv_prog_CPP=gcc -std=gnu23 -E} != ${ac_cv_prog_CPP=gcc -E}
    "ac_cv_prog_CPP"
    # prevents ac_cv_prog_cc_stdc: ${ac_cv_prog_cc_stdc=-std=gnu23} != ${ac_cv_prog_cc_stdc=}
    "ac_cv_prog_cc_stdc"
    # prevents cf_cv_cc_bool_type: ${cf_cv_cc_bool_type=1} != ${cf_cv_cc_bool_type=0}
    "cf_cv_cc_bool_type"
    # prevents cf_cv_header_stdbool_h: ${cf_cv_header_stdbool_h=0} != ${cf_cv_header_stdbool_h=1}
    "cf_cv_header_stdbool_h"
    # prevents cf_cv_timestamp: ${cf_cv_timestamp=Sat May 10 15:41:42 UTC 2025} != ${cf_cv_timestamp=Sat May 10 15:41:29 UTC 2025}
    "cf_cv_timestamp"
    # prevents ac_cv_member_struct_utmpx_ut_name: ${ac_cv_member_struct_utmpx_ut_name=yes} != ${ac_cv_member_struct_utmpx_ut_name=no}
    "ac_cv_member_struct_utmpx_ut_name"
    # prevents gl_cv_func_realloc_0_nonnull: ${gl_cv_func_realloc_0_nonnull=1} != ${gl_cv_func_realloc_0_nonnull=no}
    "gl_cv_func_realloc_0_nonnull"
    # prevents gl_cv_header_float_h_isoc23: ${gl_cv_header_float_h_isoc23=yes} != ${gl_cv_header_float_h_isoc23=no}
    "gl_cv_header_float_h_isoc23"
    # prevents ac_cv_have_decl_isfinite: ${ac_cv_have_decl_isfinite=yes} != ${ac_cv_have_decl_isfinite=no}
    "ac_cv_have_decl_isfinite"
    # prevents ac_cv_have_decl_forkpty: ${ac_cv_have_decl_forkpty=yes} != ${ac_cv_have_decl_forkpty=no}
    "ac_cv_have_decl_forkpty"
    # prevents ac_cv_func_strerror_r_char_p: ${ac_cv_func_strerror_r_char_p=yes} != ${ac_cv_func_strerror_r_char_p=no}
    "ac_cv_func_strerror_r_char_p"
  ];

  /*
    separate cleanup into its own derivation
      -> quicker iteration times (the cache build is slow, but the cleanup is fast)
      -> allows overriding/patching without having to rebuild the whole cache
      -> allows inspecting the original ./configure script that generated the cache
      -> allows inspecting the original cache file
  */
  cacheFile = runCommand "autoconf-cache-file" { } ''
    cache=$out/config.cache
    mkdir $out
    cp ${cacheFileRaw}/* $out
    chmod +w $cache
    linesBefore=$(wc -l < "$cache")

    for entry in ${toString ignoreResults}; do
      sed -i "/$entry/d" $cache
    done

    # don't cache negative header lookups, as headers can be added later
    # remove all lines from the cache which start like `ac_cv_header_` and end with `=no}`
    sed -i '/^ac_cv_header_.*=no}$/d' $cache

    # set cf_cv_timestamp to a fixed date for reproducibility
    echo 'cf_cv_timestamp="Sat May 10 15:41:29 UTC 2025"' >> $cache

    # don't cache libs which could not be found -> they can still be added later
    missingLibsLines=$(grep -E 'consider installing' $cache)
    missingLibsKeys=$(echo "$missingLibsLines" | cut -d' ' -f1 | cut -d'=' -f1)
    # remove all lines which are prefixed with one of the missing lib keys
    # if, eg. gl_cv_termcap is removed, also unset related keys like gl_cv_termcap_tparam
    for key in $missingLibsKeys; do
      sed -i "/^$key/d" $cache
    done

    # print stats
    linesAfter=$(wc -l < "$cache")
    deletedLines=$((linesBefore - linesAfter))
    echo "Autoconf cache contains $linesAfter entries after removing $deletedLines entries during cleanup."
  '';
in
makeSetupHook {
  name = "autoconf-cache-hook";
  substitutions = {
    inherit cacheFile;
  };
  passthru = {
    inherit cacheFile;
    tests.shellcheck =
      runCommand "autoconf-cache-hook-shellcheck"
        {
          nativeBuildInputs = [
            shellcheck
          ];
        }
        ''
          shellcheck ./autoconf-cache-hook.sh
          shellcheck ./autoconf-cache-debug-hook.sh
          touch $out
        '';
  };
} ./autoconf-cache-hook.sh
