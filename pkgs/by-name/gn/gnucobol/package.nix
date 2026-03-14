{
  lib,
  stdenv,
  fetchurl,
  # build files (VCS checkout only)
  # autoconf,
  # automake,
  # libtool,
  # configure helper
  pkg-config,
  # libs
  cjson,
  db,
  gmp,
  libxml2,
  ncurses,
  # docs (VCS checkout only)
  # help2man,
  # texinfo,
  # texliveBasic,
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

  # most are VCS checkout only
  # nativeBuildInputs = [
  #   pkg-config
  #   autoconf
  #   automake
  #   help2man
  #   libtool
  #   perl
  #   texinfo
  #   texliveBasic
  # ];
  nativeBuildInputs = [
    pkg-config
    perl
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
    # ./autogen.sh  only needed when building from VCS checkout
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # when building with nix on darwin, configure will use GNU strip,
    # which fails due to using --strip-unneeded, which is not supported
    substituteInPlace configure --replace-fail '"GNU strip"' 'FAKE GNU strip'
  '';

  # GCC 15 changed some warnings to errors, particularly around function pointer types
  # (C23 empty parentheses means no args, not unspecified). These flags are needed
  # until gnucobol is updated to compile cleanly with GCC 15.
  # See: https://gcc.gnu.org/gcc-15/porting_to.html
  env.CFLAGS =
    let
      # GCC 15+ needs additional flags for incompatible pointer type errors
      gcc15Flags = "-Wno-error=incompatible-pointer-types -std=gnu17";
    in
    if stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "15.0.0" then gcc15Flags else "";

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

    # Run tests (parallel via autoconf testscript)
    TESTSUITEFLAGS="--jobs=$NIX_BUILD_CORES" make check

    # Run NIST tests (parallel via make)
    cp -v ${nistTestSuite} ./tests/cobol85/newcob.val.tar.gz
    make test --jobs=$NIX_BUILD_CORES

    # Sanity check
    message="Hello, COBOL!"
    # Note: since GC 3.2 there is an auto-check for the source format,
    # for older versions we need an explicit --free to get rid of the spaces.
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

  meta = {
    description = "Free/libre COBOL compiler";
    homepage = "https://gnu.org/software/gnucobol/";
    license = with lib.licenses; [
      gpl3Plus
      lgpl3Plus
    ];
    mainProgram = "cobc";
    maintainers = with lib.maintainers; [
      lovesegfault
      techknowlogick
      kiike
    ];
    platforms = lib.platforms.all;
  };
})
