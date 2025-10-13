{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  autoconf,
  automake,
  fontconfig,
  libX11,
  perl,
  flex,
  bison,
  pkg-config,
  tcl,
  tk,
  xorg,
  yices, # bsc uses a patched version of yices
  zlib,
  ghc,
  gmp-static,
  iverilog,
  asciidoctor,
  texliveFull,
  which,
  makeBinaryWrapper,
  cctools,
  targetPackages,
  # install -m 644 lib/libstp.dylib /private/tmp/nix-build-bluespec-2024.07.drv-5/source/inst/lib/SAT
  # install: cannot stat 'lib/libstp.dylib': No such file or directory
  # https://github.com/B-Lang-org/bsc/pull/600 might fix it
  stubStp ? !stdenv.hostPlatform.isDarwin,
  withDocs ? true,
  # With 23 core parallel 10 mins on r9 5900x
  # Broken on darwin currently
  withSuiteCheck ? false,
  gnugrep,
  time,
  dejagnu,
  systemc,
  glibcLocales,
  buildPackages,
}:

let
  ghcWithPackages = ghc.withPackages (
    g:
    (with g; [
      old-time
      regex-compat
      syb
      split
    ])
  );

in
stdenv.mkDerivation rec {
  pname = "bluespec";
  version = "2024.07";

  src = fetchFromGitHub {
    owner = "B-Lang-org";
    repo = "bsc";
    rev = version;
    sha256 = "sha256-gA/vfAkkM2cuArN99JZVYEWTIJqg82HlC+BHNVS5Ot0=";
  };

  yices-src = fetchurl {
    url = "https://github.com/B-Lang-org/bsc/releases/download/${version}/yices-src-for-bsc-${version}.tar.gz";
    sha256 = "sha256-pyEdCJvmgwOYPMZEtw7aro76tSn/Y/2GcKTyARmIh4E=";
  };

  enableParallelBuilding = true;

  outputs = [
    "out"
  ]
  ++ lib.optionals withDocs [
    "doc"
  ];

  # https://github.com/B-Lang-org/bsc/pull/278 is still applicable, but will probably not be applied as such
  # there is work ongoing: https://github.com/B-Lang-org/bsc/issues/595 https://github.com/B-Lang-org/bsc/pull/600
  patches = [ ./libstp_stub_makefile.patch ];

  postUnpack = ''
    tar -C $sourceRoot/ -xf ${yices-src}
    chmod -R +rwX $sourceRoot/src/vendor/yices/v2.6/yices2
  '';

  postPatch = ''
    patchShebangs \
      src/vendor/stp/src/AST/genkinds.pl \
      src/Verilog/copy_module.pl \
      src/comp/update-build-version.sh \
      src/comp/update-build-system.sh \
      src/comp/wrapper.sh

    substituteInPlace src/comp/Makefile \
      --replace-fail 'install-bsc install-bluetcl' 'install-bsc install-bluetcl $(UTILEXES) $(SHOWRULESEXES) install-utils install-showrules'

    # For darwin
    # ld: library not found for -ltcl8.5
    substituteInPlace ./platform.sh \
      --replace-fail 'TCLSH=/usr/bin/tclsh' 'TCLSH=`which tclsh`'
  ''
  + lib.optionalString withSuiteCheck ''
    substituteInPlace testsuite/bsc.options/verilog-e/verilog-e.exp \
      --replace-fail "/bin/echo" "${lib.getExe' buildPackages.coreutils "echo"}"

    substituteInPlace testsuite/test_list.sh testsuite/findfailures.csh \
      --replace-fail "bin/csh" "${lib.getExe buildPackages.tcsh}"

    patchShebangs \
      testsuite/test_list.sh \
      testsuite/findfailures.csh \
      scripts/tool-find.sh \
      testsuite/bsc.bluetcl/packages/expandPorts/compareOutput.pl \
      testsuite/bsc.bsv_examples/AES/funcit.pl \
      testsuite/bsc.bsv_examples/AES/makeVecs.pl \
      testsuite/bsc.bsv_examples/AES/makeVecs192.pl \
      testsuite/bsc.bsv_examples/AES/makeVecs256.pl \
      testsuite/bsc.if/split/canonicalize.pl \
      testsuite/bsc.interra/operators/Arith/generate/gen.pl \
      testsuite/bsc.interra/operators/Arith/generate/sort.pl \
      testsuite/bsc.interra/operators/BitSel/generate/gen.pl \
      testsuite/bsc.interra/operators/BitSel/generate/sort.pl \
      testsuite/bsc.interra/operators/Logic/generate/gen.pl \
      testsuite/bsc.interra/operators/Logic/generate/sort.pl \
      testsuite/bsc.preprocessor/ifdef/iftestcase-perl.pl \
      testsuite/bsc.verilog/filter/basicinout.pl \
      testsuite/scripts/collapse.pl \
      testsuite/scripts/double-directory.pl \
      testsuite/scripts/process-summary-file.pl \
      testsuite/scripts/sort-by-time.pl \
      testsuite/scripts/times-by-directory.pl
  '';

  preBuild = ''
    # allow running bsc to bootstrap
    export LD_LIBRARY_PATH=$PWD/inst/lib/SAT

    # use more cores for GHC building, 44 causes heap overflows in ghc, and
    # there is not much speedup after 8..
    if [[ $NIX_BUILD_CORES -gt 8 ]] ; then export GHCJOBS=8; else export GHCJOBS=$NIX_BUILD_CORES; fi
  '';

  buildInputs = yices.buildInputs ++ [
    fontconfig
    libX11 # tcltk
    tcl
    tk
    which
    xorg.libXft
    zlib
  ];

  nativeBuildInputs = [
    automake
    autoconf
    bison
    flex
    ghcWithPackages
    perl
    pkg-config
    tcl
    makeBinaryWrapper
  ]
  ++ lib.optionals withDocs [
    texliveFull
    asciidoctor
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # https://github.com/B-Lang-org/bsc/blob/main/src/comp/bsc.hs#L1838
    # /nix/store/7y0vlsf6l8lr3vjsbrirqrsbx4mwqiwf-cctools-binutils-darwin-1010.6/bin/strip: error: unknown argument '-u'
    # make[1]: *** [Makefile:97: smoke_test_bluesim] Error 1
    cctools
  ];

  env.NIX_CFLAGS_COMPILE = toString (
    lib.optionals (stdenv.cc.isClang) [
      # wide_data.cxx:1750:15: error: variable length arrays in C++ are a Clang extension [-Werror,-Wvla-cxx-extension]
      "-Wno-error"
    ]
  );

  makeFlags = [
    "NO_DEPS_CHECKS=1" # skip the subrepo check (this deriviation uses yices-src instead of the subrepo)
    "NOGIT=1" # https://github.com/B-Lang-org/bsc/issues/12
    "LDCONFIG=ldconfig" # https://github.com/SRI-CSL/yices2/blob/fda0a325ea7923f152ea9f9a5d20eddfd1d96224/Makefile.build#L66
    (if withDocs then "release" else "install-src")
  ]
  ++ lib.optionals stubStp [
    "STP_STUB=1" # uses yices as a SMT solver and stub out STP
  ];

  installPhase = ''
    mkdir -p $out
    mv inst/bin $out
    mv inst/lib $out

  ''
  + lib.optionalString withDocs ''
    # fragile, I know..
    mkdir -p $doc/share/doc/bsc
    mv inst/README $doc/share/doc/bsc
    mv inst/ReleaseNotes.* $doc/share/doc/bsc
    mv inst/doc/*.pdf $doc/share/doc/bsc
  '';

  postFixup = ''
    # https://github.com/B-Lang-org/bsc/blob/65e3a87a17f6b9cf38cbb7b6ad7a4473f025c098/src/comp/bsc.hs#L1839
    # `/bin/bsc` is a bash script which the script name to call the binary in the `/bin/core` directory
    # thus wrapping `/bin/bsc` messes up the scriptname detection in it.
    wrapProgram $out/bin/core/bsc \
      --prefix PATH : ${
        lib.makeBinPath (if stdenv.hostPlatform.isDarwin then [ cctools ] else [ targetPackages.stdenv.cc ])
      }
  '';

  doCheck = true;
  doInstallCheck = true;

  # TODO To fix check-suite:
  # On darwin
  # ```
  # FAIL: `Cpreprocess_line.bsv.bsc-out' differs from `Cpreprocess_line.bsv.bsc-out.expected'

  # FAIL: `sysGCD.bsc-vcomp-out.filtered' differs from `empty.expected'

  # FAIL: module `' in `ImpArgConnect3.bsv' should compile to Verilog
  # Caught error in sed: sed: can't read mkArgImpConnect3.v: No such file or directory
  # FAIL: `mkArgImpConnect3.v.filtered' differs from `mkArgImpConnect3.v.expected.filtered'
  # ```

  checkTarget = if withSuiteCheck then "checkparallel" else "check-smoke"; # this is the shortest check but "check-suite" tests much more

  # bash: warning: setlocale: LC_ALL: cannot change locale (en_US.UTF-8)
  LOCALE_ARCHIVE = lib.optionalString (
    withSuiteCheck && stdenv.hostPlatform.isLinux
  ) "${glibcLocales}/lib/locale/locale-archive";

  nativeCheckInputs = [
    gmp-static
    iverilog
  ]
  ++ lib.optionals withSuiteCheck [
    time
    dejagnu # for `/bin/runtest` in `check-suite`
    gnugrep # `testsuite/bsc.interra/operators/Arith/arith.exp` and more
  ];

  checkInputs = lib.optionals withSuiteCheck [
    systemc
  ];

  checkPhase = lib.optionalString withSuiteCheck ''
    (
      cd testsuite
      set +e # disable exit on error
      make -j $NIX_BUILD_CORES $checkTarget
      test_exit_code=$?
      set -e
      failures=$(./findfailures.csh)
      echo "$failures"
      for failure in $failures; do
        logpath="''${failure/%sum/log}"
        echo "\nFAILURE LOG: $logpath"
        cat "$logpath"
        echo "END LOG: $logpath"
      done

      if [[ "$test_exit_code" != "0" || -n "$failures" ]]; then
        echo "Some tests failed or the makefile failed to run"
        exit 1
      fi
    )
  '';

  installCheckPhase = ''
    output="$($out/bin/bsc 2>&1 || true)"
    echo "bsc output:"
    echo "$output"
    echo "$output" | grep -q "to get help"
  '';

  meta = {
    description = "Toolchain for the Bluespec Hardware Definition Language";
    homepage = "https://github.com/B-Lang-org/bsc";
    license = lib.licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ]
    ++ lib.platforms.darwin;
    mainProgram = "bsc";
    maintainers = with lib.maintainers; [
      jcumming
      thoughtpolice
    ];
  };
}
