{
  lib,
  stdenv,
  fetchurl,
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

  src = fetchurl {
    url = "mirror://gnu/gnucobol/gnucobol-${finalAttrs.version}.tar.xz";
    hash = "sha256-O7SK9GztR3n6z0H9wu5g5My4bqqZ0BCzZoUxXfOcLuI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    help2man
    libtool
    perl
    texinfo
    texliveBasic
  ];

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
    sed -i '/^AT_CHECK.*crud\.cob/i AT_SKIP_IF([true])' tests/testsuite.src/listings.at
    # upstream reports the following tests as known failures
    # test 843 (runtime check: write to internal storage (1))
    sed -i "/^843;/d" tests/testsuite
    # test 875 (INDEXED sample)
    sed -i "/^875;/d" tests/testsuite

    # gnucobol.texi:2765: no matching `@end verbatim'
    sed -i "214i @end verbatim" doc/cbrunt.tex
  '';

  preConfigure = ''
    autoconf
    aclocal
    automake
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # when building with nix on darwin, configure will use GNU strip,
    # which fails due to using --strip-unneeded, which is not supported
    substituteInPlace configure --replace-fail '"GNU strip"' 'FAKE GNU strip'
  '';

  # error: call to undeclared function 'xmlCleanupParser'
  # ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
  env.CFLAGS = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-error=implicit-function-declaration";

  enableParallelBuilding = true;

  installFlags = [
    "install-pdf"
    "install-html"
    "localedir=$out/share/locale"
  ];

  # Tests must run after install.
  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    # Run tests
    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make check

    # Run NIST tests
    cp -v ${nistTestSuite} ./tests/cobol85/newcob.val.tar.gz
    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make test

    # Sanity check
    message="Hello, COBOL!"
    # XXX: Don't for a second think you can just get rid of these spaces, they
    # are load bearing.
    tee hello.cbl <<EOF
           IDENTIFICATION DIVISION.
           PROGRAM-ID. HELLO.

           PROCEDURE DIVISION.
           DISPLAY "$message".
           STOP RUN.
    EOF
    $bin/bin/cobc -x -o hello-cobol "hello.cbl"
    hello="$(./hello-cobol | tee >(cat >&2))"
    [[ "$hello" == "$message" ]] || exit 1

    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "Free/libre COBOL compiler";
    homepage = "https://gnu.org/software/gnucobol/";
    license = with licenses; [
      gpl3Only
      lgpl3Only
    ];
    maintainers = with maintainers; [
      lovesegfault
      techknowlogick
      kiike
    ];
    platforms = platforms.all;
  };
})
