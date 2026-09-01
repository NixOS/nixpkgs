{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  autoconf,
  automake,
  libtool,
  pkg-config,
  # libs
  cjson,
  db,
  gmp,
  libxml2,
  ncurses,
  # docs
  help2man,
  texinfo,
  texliveBasic,
  # test
  perl,
  runCommandCC,
  versionCheckHook,
}:
let
  nistTestSuite = fetchurl {
    # Used to check GnuCOBOL with the NIST test suite
    url = "mirror://sourceforge/gnucobol/newcob.val.tar.gz";
    hash = "sha256-5FE/JqmziRH3v4gv49MzmoC0XKvCyvheswVbD1zofuA=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gnucobol";
  version = "3.2";

  strictDeps = true;

  src = fetchurl {
    url = "mirror://gnu/gnucobol/gnucobol-${finalAttrs.version}.tar.xz";
    hash = "sha256-O7SK9GztR3n6z0H9wu5g5My4bqqZ0BCzZoUxXfOcLuI=";
  };

  nativeBuildInputs = [
    pkg-config
    help2man
    libtool
    perl
    texinfo
    texliveBasic
  ]
  ++ (
    if stdenv.hostPlatform.isDarwin then
      # autoreconf runs aclocal before autoconf, which messes up some compiler
      # definition and causes many tests to fail (with segfaults)
      [
        automake
        autoconf
      ]
    else
      [ autoreconfHook ]
  );

  buildInputs = [
    cjson
    db
    gmp
    libxml2
    ncurses
  ];

  outputs = [
    "bin"
    "dev"
    "lib"
    "out"
  ];
  # XXX: Without this, we get a cycle between bin and dev
  propagatedBuildOutputs = [ ];

  patches = [
    ./fix-libxml2-include.patch
  ];

  # Skips a broken test
  postPatch = ''
    # upstream reports the following tests as known failures
    sed -i '/AT_SETUP(\[runtime check: write to internal storage (1)\])/a \
             AT_SKIP_IF(\[true\])' tests/testsuite.src/run_misc.at
    # gnucobol.texi:2765: no matching `@end verbatim'
    sed -i "214i @end verbatim" doc/cbrunt.tex
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    sed -i '/AT_SETUP(\[INDEXED sample\])/a \
             AT_SKIP_IF(\[true\])' tests/testsuite.src/run_file.at
  '';

  preConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    autoconf
    aclocal
    automake
    # when building with nix on darwin, configure will use GNU strip,
    # which fails due to using --strip-unneeded, which is not supported
    substituteInPlace configure --replace-fail '"GNU strip"' 'FAKE GNU strip'
  '';

  # GCC 15 changed some warnings to errors, particularly around function pointer types
  # (C23 empty parentheses means no args, not unspecified). These flags are needed
  # until gnucobol is updated to compile cleanly with GCC 15+/latest LLVM.
  # See: https://gcc.gnu.org/gcc-15/porting_to.html
  env.CFLAGS = "-std=gnu17";
  enableParallelBuilding = true;

  installFlags = [
    "localedir=$out/share/locale"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin) [
    "install-pdf"
    "install-html"
  ];

  # Needs to be install check for macos, inbuilt tests fail unless they are installed first
  doCheck = false;
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "bin"}/bin/cob-config";
  installCheckPhase = ''
    runHook preInstallCheck

    # Run tests (parallel via autoconf testscript)
    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make check

    # Run NIST tests (parallel via make)
    cp -v ${nistTestSuite} ./tests/cobol85/newcob.val.tar.gz
    make test --jobs=$NIX_BUILD_CORES

    runHook postInstallCheck
  '';

  passthru.tests.hello =
    runCommandCC "hello-cobol"
      {
        nativeBuildInputs = [ finalAttrs.finalPackage.bin ];
      }
      ''
        cp ${./hello.cbl} hello.cbl
        cobc -x -o hello-cobol "hello.cbl"
        hello="$(./hello-cobol | tee >(cat >&2))"
        [[ "$hello" == "Hello, COBOL!" ]] || exit 1
        touch $out
      '';

  meta = {
    description = "Free/libre COBOL compiler";
    homepage = "https://gnu.org/software/gnucobol/";
    license = with lib.licenses; [
      gpl3Only
      lgpl3Only
    ];
    mainProgram = "cobc";
    maintainers = with lib.maintainers; [
      lovesegfault
      techknowlogick
      kiike
      sempiternal-aurora
    ];
    teams = [ lib.teams.ngi ];
    platforms = lib.platforms.all;
  };
})
