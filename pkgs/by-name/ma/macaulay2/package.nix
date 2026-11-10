{
  fetchFromGitHub,
  fetchurl,
  lib,
  makeWrapper,
  runCommand,
  stdenv,

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
  fflas-ffpack,
  flex,
  flint,
  frobby,
  gdbm,
  getconf,
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
  runtimeShell,
  topcom,
  which,
  xz,
  llvmPackages,

  downloadDocs ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "macaulay2";
  version = "1.26.06";

  src = fetchFromGitHub {
    owner = "Macaulay2";
    repo = "M2";
    tag = "release-${finalAttrs.version}";
    hash = "sha256-kYxqbMKW+7r6nI4i3o7vvJVf0TGRVLaDviZTFx3PTBI=";
  };

  docs = fetchurl {
    url = "https://macaulay2.com/Downloads/OtherSourceCode/Macaulay2-docs-${finalAttrs.version}.tar.gz";
    hash = "sha256-0+ilvDh87Gmwzx0bLhT6nnadcPwgU3uB6pKhP9VqW0Q=";
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
    getconf
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
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  nativeBuildInputs = [
    autoreconfHook
    bison
    flex
    flint
    gdbm
    getconf
    gfortran
    makeWrapper
    pkg-config
    R
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
    # remove editor stuff from Makefiles
    substituteInPlace Macaulay2/Makefile.in \
      --replace-fail "all-in-editors" "" \
      --replace-fail "editors" ""
  '';

  preConfigure = ''
    cd BUILD/build
  '';

  configureScript = "../../configure";

  configureFlags = [
    "--disable-download"
    "--enable-shared"
    "--with-issue=Nix"
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

  env.LDFLAGS = lib.concatStringsSep " " (
    lib.optionals stdenv.hostPlatform.isDarwin [
      "-lblas"
    ]
  );

  postInstall = ''
    rm "$out/bin/M2"

    makeWrapper "$out/bin/M2-binary" "$out/bin/M2" \
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
      --prefix ${
        if stdenv.hostPlatform.isDarwin then "DYLD_LIBRARY_PATH" else "LD_LIBRARY_PATH"
      } : $out/lib/Macaulay2/lib:${
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

  # run engine tests only
  checkFlags = [
    "-C"
    "Macaulay2/e"
  ];

  doCheck = true;

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
          ];
        }
        ''
          M2 -q --check 2 && touch $out
        '';

    all-packages =
      runCommand "macaulay2-all-package-tests"
        {
          nativeBuildInputs = [
            finalAttrs.finalPackage
          ];
        }
        ''
          M2 -q --check 3 && touch $out
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
    changelog = "https://macaulay2.com/doc/Macaulay2/share/doc/Macaulay2/Macaulay2Doc/html/_changes_cm_sp${finalAttrs.version}.html";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ coolcuber ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
