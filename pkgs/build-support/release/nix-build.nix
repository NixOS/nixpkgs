# This function builds and tests an Autoconf-style source tarball.
# The result can be installed normally in an environment (e.g., after
# making it available through a channel).  If `doCoverageAnalysis' is
# true, it does an ordinary build from a source tarball, except that
# it turns on GCC's coverage analysis feature.  It then runs `make
# check' and produces a coverage analysis report using `lcov'.

args: with args;

stdenv.mkDerivation (

  {
    name = "nix-build";

    # Also run a `make check'.
    doCheck = true;

    # When doing coverage analysis, we don't care about the result.
    dontInstall = doCoverageAnalysis;

    showBuildStats = true;

    lcovFilter = ["/nix/store/*"];

    # Hack - swap checkPhase and installPhase (otherwise Stratego barfs).
    phases = "unpackPhase patchPhase configurePhase buildPhase installPhase checkPhase fixupPhase distPhase ${if doCoverageAnalysis then "coverageReportPhase" else ""}";
  }

  // args // 

  {
    src = src.path;

    postHook = ''
      ensureDir $out/nix-support
      echo "$system" > $out/nix-support/system

      if test -z "${toString doCoverageAnalysis}"; then
          echo "nix-build none $out" >> $out/nix-support/hydra-build-products
      fi

      # If `src' is the result of a call to `makeSourceTarball', then it
      # has a subdirectory containing the actual tarball(s).  If there are
      # multiple tarballs, just pick the first one.
      echo $src
      if test -d $src/tarballs; then
          src=$(ls $src/tarballs/*.tar.bz2 $src/tarballs/*.tar.gz | sort | head -1)
      fi

      # Hack to compress log files.  Prevents (by pointer hiding!)
      # unnecessary dependencies.
      startLogWrite() {
          # Use process substitution to send the FIFO output to both
          # stdout and bzip2.
          bash -c "tee >(bzip2 > \"$1\".bz2) < \"$2\"" &
          logWriterPid=$!
      }

      # Set GCC flags for coverage analysis, if desired.
      if test -n "${toString doCoverageAnalysis}"; then
          export NIX_CFLAGS_COMPILE="-O0 -fprofile-arcs -ftest-coverage $NIX_CFLAGS_COMPILE"
          export CFLAGS="-O0"
          export CXXFLAGS="-O0"
      fi

    ''; # */


    # In the report phase, create a coverage analysis report.
    coverageReportPhase = if doCoverageAnalysis then ''
      ${args.lcov}/bin/lcov --directory . --capture --output-file app.info
      set -o noglob
      ${args.lcov}/bin/lcov --remove app.info $lcovFilter > app2.info
      set +o noglob
      mv app2.info app.info
      mkdir $out/coverage
      ${args.lcov}/bin/genhtml app.info -o $out/coverage > log

      # Grab the overall coverage percentage for use in release overviews.
      grep "Overall coverage rate" log | sed 's/^.*(\(.*\)%).*$/\1/' > $out/nix-support/coverage-rate

      echo "report coverage $out/coverage" >> $out/nix-support/hydra-build-products
    '' else "";


    meta = {
      description = if doCoverageAnalysis then "Coverage analysis" else "Native Nix build on ${stdenv.system}";
    };

  }
)
