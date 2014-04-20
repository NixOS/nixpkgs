# This function builds and tests an Autoconf-style source tarball.
# The result can be installed normally in an environment (e.g., after
# making it available through a channel).  If `doCoverageAnalysis' is
# true, it does an ordinary build from a source tarball, except that
# it turns on GCC's coverage analysis feature.  It then runs `make
# check' and produces a coverage analysis report using `lcov'.

{ buildOutOfSourceTree ? false
, preConfigure ? null
, doCoverageAnalysis ? false
, lcovFilter ? []
, lcovExtraTraceFiles ? []
, src, stdenv
, name ? if doCoverageAnalysis then "nix-coverage" else "nix-build"
, failureHook ? null
, prePhases ? []
, postPhases ? []
, buildInputs ? []
, ... } @ args:

stdenv.mkDerivation (

  {
    # Also run a `make check'.
    doCheck = true;

    # When doing coverage analysis, we don't care about the result.
    dontInstall = doCoverageAnalysis;
    useTempPrefix = doCoverageAnalysis;

    showBuildStats = true;

    finalPhase =
      ''
        # Propagate the release name of the source tarball.  This is
        # to get nice package names in channels.
        if test -e $origSrc/nix-support/hydra-release-name; then
          cp $origSrc/nix-support/hydra-release-name $out/nix-support/hydra-release-name
        fi
      '';

    failureHook = (stdenv.lib.optionalString (failureHook != null) failureHook) +
    ''
      if test -n "$succeedOnFailure"; then
          if test -n "$keepBuildDirectory"; then
              KEEPBUILDDIR="$out/`basename $TMPDIR`"
              header "Copying build directory to $KEEPBUILDDIR"
              mkdir -p $KEEPBUILDDIR
              cp -R "$TMPDIR/"* $KEEPBUILDDIR
              stopNest
          fi
      fi
    '';
  }

  // args //

  {
    name = name + (if src ? version then "-" + src.version else "");

    postHook = ''
      . ${./functions.sh}
      origSrc=$src
      src=$(findTarballs $src | head -1)
    '';

    initPhase = ''
      mkdir -p $out/nix-support
      echo "$system" > $out/nix-support/system

      if [ -z "${toString doCoverageAnalysis}" ]; then
          for i in $outputs; do
              if [ "$i" = out ]; then j=none; else j="$i"; fi
              mkdir -p ''${!i}/nix-support
              echo "nix-build $j ''${!i}" >> ''${!i}/nix-support/hydra-build-products
          done
      fi
    '';

    prePhases = ["initPhase"] ++ prePhases;

    buildInputs = buildInputs ++ stdenv.lib.optional doCoverageAnalysis args.makeGCOVReport;

    lcovFilter = ["/nix/store/*"] ++ lcovFilter;

    inherit lcovExtraTraceFiles;

    postPhases = postPhases ++ ["finalPhase"];

    meta = (if args ? meta then args.meta else {}) // {
      description = if doCoverageAnalysis then "Coverage analysis" else "Nix package for ${stdenv.system}";
    };

  }

  //

  (if buildOutOfSourceTree
   then {
     preConfigure =
       # Build out of source tree and make the source tree read-only.  This
       # helps catch violations of the GNU Coding Standards (info
       # "(standards) Configuration"), like `make distcheck' does.
       '' mkdir "../build"
          cd "../build"
          configureScript="../$sourceRoot/configure"
          chmod -R a-w "../$sourceRoot"

          echo "building out of source tree, from \`$PWD'..."

          ${if preConfigure != null then preConfigure else ""}
       '';
   }
   else {})
)
