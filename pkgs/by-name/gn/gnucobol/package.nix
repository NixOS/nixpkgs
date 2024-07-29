{
  lib,
  stdenv,
  fetchurl,
  # Using autoconf 2.69 as that's the targeted version by upstream
  autoconf269,
  automake,
  libtool,
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
    autoconf269
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

  postPatch = lib.optionalString stdenv.hostPlatform.isAarch64 ''
    # Skip test 843 (runtime check: write to internal storage (1)) on aarch64
    sed -i "/^843;/d" tests/testsuite
  '';

  preConfigure = ''
    autoconf
    aclocal
    automake
  '';

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
    make -j$NIX_BUILD_CORES check

    # Run NIST tests
    cp -v ${nistTestSuite} ./tests/cobol85/newcob.val.tar.gz
    make -j$NIX_BUILD_CORES test

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
      kiike
      ericsagnes
      lovesegfault
    ];
    platforms = platforms.all;
  };
})
