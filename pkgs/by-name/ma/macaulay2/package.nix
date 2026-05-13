{
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  runCommand,
  stdenv,
  writableTmpDirAsHomeHook,

  _4ti2,
  autoreconfHook,
  bison,
  blas,
  boehmgc,
  boost,
  cddlib,
  cohomcalg,
  csdp,
  eigen,
  emacs-nox,
  fflas-ffpack,
  flex,
  flint,
  frobby,
  gdbm,
  gfortran,
  gfan,
  givaro,
  glpk,
  gtest,
  icu,
  jansson,
  libffi,
  libxml2,
  libz,
  lrs,
  mathic,
  mathicgb,
  memtailor,
  mpfi,
  mpfr,
  msolve,
  mpsolve,
  nauty,
  normaliz,
  ntl,
  onetbb,
  openssl,
  R,
  rWrapper,
  pkg-config,
  python3,
  readline,
  singular,
  texinfo,
  time,
  topcom,
  which,
  xz,

  downloadDocs ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "macaulay2";
  version = "1.26.05";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-UiPLownaFtuYFUlZhBl+Nl/sRZRhG9OUwepZtFTkTqc";
    fetchSubmodules = true;
  };

  docs = fetchurl {
    url = "https://macaulay2.com/Downloads/OtherSourceCode/Macaulay2-docs-${finalAttrs.version}.tar.gz";
    hash = "sha256-rz9b7HvxfxI978yM9wE7XvLu7DO38i/amokXBU0RjSg=";
  };

  buildInputs = [
    blas
    boehmgc
    boost
    cddlib
    eigen
    fflas-ffpack
    flint
    frobby
    gdbm
    givaro
    glpk
    gtest
    icu
    jansson
    libffi
    libxml2
    libz
    mathic
    mathicgb
    memtailor
    mpfi
    mpfr
    mpsolve
    msolve
    nauty
    ntl
    normaliz
    onetbb
    openssl
    python3
    readline
    singular
    xz
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    emacs-nox
    flex
    gdbm
    gfortran
    makeWrapper
    pkg-config
    texinfo
    which

    # TODO the configure script looks for these in $PATH
    _4ti2
    cohomcalg
    csdp
    gfan
    lrs
    msolve
    nauty
    normaliz
    topcom
  ];

  __structuredAttrs = true;

  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/M2";

  postPatch = ''
    sed -i 's/AC_SUBST(REL,.*uname -r.*)/AC_SUBST(REL,"")/' configure.ac
  '';

  preConfigure = ''
    cd BUILD/build
  '';

  configureScript = "../../configure";

  configureFlags = [
    "--disable-download"
    "--enable-shared"
    "--with-issue=nixos"
    "--with-boost-libdir=${boost}/lib"
    "--with-system-libs"
    "CPPFLAGS=-I${lib.getDev cddlib}/include/cddlib"
    "PYTHON_BIN=${python3.interpreter}"
  ];

  configurePlatforms = [
    "build"
    "host"
  ];

  enableParallelBuilding = true;

  preBuild = lib.optionalString downloadDocs ''
    ln -s ${finalAttrs.docs} ../tarfiles/${finalAttrs.docs.name}
    make -C libraries all-in-Macaulay2-docs
  '';

  buildFlags = lib.optionals downloadDocs [
    "MakeDocumentation=false"
  ];

  postInstall = ''
    wrapProgram "$out/bin/M2" \
      --prefix PATH : ${
        lib.makeBinPath [
          _4ti2
          cohomcalg
          csdp
          gfan
          lrs
          msolve
          nauty
          normaliz
          openssl
          R
          topcom
        ]
      } \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          cddlib
          flint
          givaro
          glpk
          mpfi
          mpfr
          mpsolve
          normaliz
          ntl
          singular
        ]
      } \
      --prefix R_LIBS_SITE : ${lib.makeSearchPath "library" rWrapper.recommendedPackages}
  '';

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/M2 --check 1
    runHook postInstallCheck
  '';

  doInstallCheck = true;

  passthru.tests = {
    core =
      runCommand "macaulay2-core-tests"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            writableTmpDirAsHomeHook
          ];
        }
        ''
          M2 --check 2 && touch $out
        '';

    all-packages =
      runCommand "macaulay2-all-packages-test"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
            writableTmpDirAsHomeHook
          ];
        }
        ''
          M2 --check 3 && touch $out
        '';
  };

  meta = {
    description = "System for computing in commutative algebra, algebraic geometry and related fields";
    mainProgram = "M2";
    longDescription = ''
      Macaulay2 is a software system devoted to supporting research in
      algebraic geometry and commutative algebra, whose creation has been
      funded by the National Science Foundation since 1992.

      Macaulay2 includes core algorithms for computing Gröbner bases and graded
      or multi-graded free resolutions of modules over quotient rings of graded
      or multi-graded polynomial rings with a monomial ordering. The core
      algorithms are accessible through a versatile high level interpreted user
      language with a powerful debugger supporting the creation of new classes
      of mathematical objects and the installation of methods for computing
      specifically with them. Macaulay2 can compute Betti numbers, Ext,
      cohomology of coherent sheaves on projective varieties, primary
      decomposition of ideals, integral closure of rings, and more.
    '';
    homepage = "https://macaulay2.com/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ coolcuber ];
  };
})
