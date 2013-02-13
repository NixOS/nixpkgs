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
              cp -R $TMPDIR/* $KEEPBUILDDIR
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

      # Set GCC flags for coverage analysis, if desired.
      if test -n "${toString doCoverageAnalysis}"; then
          export NIX_CFLAGS_COMPILE="-O0 --coverage $NIX_CFLAGS_COMPILE"
          export CFLAGS="-O0"
          export CXXFLAGS="-O0"
      fi
    ''; # */

    initPhase = ''
      mkdir -p $out/nix-support
      echo "$system" > $out/nix-support/system

      if [ -z "${toString doCoverageAnalysis}" ]; then
          for i in $outputs; do
              if [ "$i" = out ]; then j=none; else j="$i"; fi
              echo "nix-build $j ''${!i}" >> $out/nix-support/hydra-build-products
          done
      fi
    '';

    prePhases = ["initPhase"] ++ prePhases;

    # In the report phase, create a coverage analysis report.
    coverageReportPhase = if doCoverageAnalysis then ''
      ${args.lcov}/bin/lcov --directory . --capture --output-file app.info
      set -o noglob
      ${args.lcov}/bin/lcov --remove app.info $lcovFilter > app2.info
      set +o noglob
      mv app2.info app.info

      mkdir $out/coverage
      ${args.lcov}/bin/genhtml app.info $lcovExtraTraceFiles -o $out/coverage > log

      # Grab the overall coverage percentage for use in release overviews.
      grep "Overall coverage rate" log | sed 's/^.*(\(.*\)%).*$/\1/' > $out/nix-support/coverage-rate

      echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
    '' else "";


    lcovFilter = ["/nix/store/*"] ++ lcovFilter;

    inherit lcovExtraTraceFiles;

    postPhases = postPhases ++
      (stdenv.lib.optional doCoverageAnalysis "coverageReportPhase") ++ ["finalPhase"];

    meta = (if args ? meta then args.meta else {}) // {
      description = if doCoverageAnalysis then "Coverage analysis" else "Native Nix build on ${stdenv.system}";
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
