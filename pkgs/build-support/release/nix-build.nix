# This function builds and tests an Autoconf-style source tarball.
# The result can be installed normally in an environment (e.g., after
# making it available through a channel).  If `doCoverageAnalysis' is
# true, it does an ordinary build from a source tarball, except that
# it turns on GCC's coverage analysis feature.  It then runs `make
# check' and produces a coverage analysis report using `lcov'.

{
  buildOutOfSourceTree ? false,
  preConfigure ? null,
  doCoverageAnalysis ? false,
  doClangAnalysis ? false,
  doCoverityAnalysis ? false,
  lcovFilter ? [ ],
  lcovExtraTraceFiles ? [ ],
  src,
  lib,
  stdenv,
  name ? if doCoverageAnalysis then "nix-coverage" else "nix-build",
  failureHook ? null,
  prePhases ? [ ],
  postPhases ? [ ],
  buildInputs ? [ ],
  preHook ? "",
  postHook ? "",
  ...
}@args:

let
  doingAnalysis = doCoverageAnalysis || doClangAnalysis || doCoverityAnalysis;
in
stdenv.mkDerivation (

  {
    # Also run a `make check'.
    doCheck = true;

    # When doing coverage analysis, we don't care about the result.
    dontInstall = doingAnalysis;
    useTempPrefix = doingAnalysis;

    showBuildStats = true;

    finalPhase = ''
      # Propagate the release name of the source tarball.  This is
      # to get nice package names in channels.
      if test -e $origSrc/nix-support/hydra-release-name; then
        cp $origSrc/nix-support/hydra-release-name $out/nix-support/hydra-release-name
      fi

      # Package up Coverity analysis results
      if [ ! -z "${toString doCoverityAnalysis}" ]; then
        if [ -d "_coverity_$name/cov-int" ]; then
          mkdir -p $out/tarballs
          NAME=`cat $out/nix-support/hydra-release-name`
          cd _coverity_$name
          tar caf $out/tarballs/$NAME-coverity-int.xz cov-int
          echo "file cov-build $out/tarballs/$NAME-coverity-int.xz" >> $out/nix-support/hydra-build-products
        fi
      fi

      # Package up Clang analysis results
      if [ ! -z "${toString doClangAnalysis}" ]; then
        if [ ! -z "`ls _clang_analyze_$name`" ]; then
          cd  _clang_analyze_$name && mv * $out/analysis
        else
          mkdir -p $out/analysis
          echo "No bugs found." >> $out/analysis/index.html
        fi

        echo "report analysis $out/analysis" >> $out/nix-support/hydra-build-products
      fi
    '';

    failureHook = (lib.optionalString (failureHook != null) failureHook) + ''
      if test -n "$succeedOnFailure"; then
          if test -n "$keepBuildDirectory"; then
              KEEPBUILDDIR="$out/`basename $TMPDIR`"
              echo "Copying build directory to $KEEPBUILDDIR"
              mkdir -p $KEEPBUILDDIR
              cp -R "$TMPDIR/"* $KEEPBUILDDIR
          fi
      fi
    '';
  }

  // removeAttrs args [ "lib" ] # Propagating lib causes the evaluation to fail, because lib is a function that can't be converted to a string

  // {
    name = name + (lib.optionalString (src ? version) "-${src.version}");

    postHook = ''
      . ${./functions.sh}
      origSrc=$src
      src=$(findTarball $src)
      ${postHook}
    '';

    preHook = ''
      # Perform Coverity Analysis
      if [ ! -z "${toString doCoverityAnalysis}" ]; then
        shopt -s expand_aliases
        mkdir _coverity_$name
        alias make="cov-build --dir _coverity_$name/cov-int make"
      fi

      # Perform Clang Analysis
      if [ ! -z "${toString doClangAnalysis}" ]; then
        shopt -s expand_aliases
        alias make="scan-build -o _clang_analyze_$name --html-title='Scan results for $name' make"
      fi

      ${preHook}
    '';

    # Clean up after analysis
    postBuild = ''
      if [ ! -z "${toString (doCoverityAnalysis || doClangAnalysis)}" ]; then
        unalias make
      fi
    '';

    initPhase = ''
      mkdir -p $out/nix-support
      echo "$system" > $out/nix-support/system

      if [ -z "${toString doingAnalysis}" ]; then
          for i in $(getAllOutputNames); do
              if [ "$i" = out ]; then j=none; else j="$i"; fi
              mkdir -p ''${!i}/nix-support
              echo "nix-build $j ''${!i}" >> ''${!i}/nix-support/hydra-build-products
          done
      fi
    '';

    prePhases = [ "initPhase" ] ++ prePhases;

    buildInputs =
      buildInputs
      ++ (lib.optional doCoverageAnalysis args.makeGCOVReport)
      ++ (lib.optional doClangAnalysis args.clang-analyzer)
      ++ (lib.optional doCoverityAnalysis args.cov-build)
      ++ (lib.optional doCoverityAnalysis args.xz);

    lcovFilter = [ "${builtins.storeDir}/*" ] ++ lcovFilter;

    inherit lcovExtraTraceFiles;

    postPhases = postPhases ++ [ "finalPhase" ];

    meta = (lib.optionalAttrs (args ? meta) args.meta) // {
      description =
        if doCoverageAnalysis then "Coverage analysis" else "Nix package for ${stdenv.hostPlatform.system}";
    };

  }

  //

    (lib.optionalAttrs buildOutOfSourceTree {
      preConfigure =
        # Build out of source tree and make the source tree read-only.  This
        # helps catch violations of the GNU Coding Standards (info
        # "(standards) Configuration"), like `make distcheck' does.
        ''
          mkdir "../build"
          cd "../build"
          configureScript="../$sourceRoot/configure"
          chmod -R a-w "../$sourceRoot"

          echo "building out of source tree, from \`$PWD'..."

          ${lib.optionalString (preConfigure != null) preConfigure}
        '';
    })
)
