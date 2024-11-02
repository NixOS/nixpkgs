{
  lib,
  bison,
  buildPackages,
  fetchurl,
  installShellFiles,
  pkgsBuildTarget,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ftjam";
  version = "2.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/freetype/ftjam/${finalAttrs.version}/ftjam-${finalAttrs.version}.tar.bz2";
    hash = "sha256-6JdzUAqSkS3pGOn+v/q+S2vOedaa8ZRDX04DK4ptZqM=";
  };

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [
    bison
    installShellFiles
  ];

  # Doesn't understand how to cross compile once bootstrapped, so we'll just use
  # the Makefile for the bootstrapping portion
  configurePlatforms = [
    "build"
    "target"
  ];

  configureFlags = [
    "CC=${buildPackages.stdenv.cc.targetPrefix}cc"
    "--host=${stdenv.buildPlatform.config}"
  ];

  makeFlags = [
    "CC=${buildPackages.stdenv.cc.targetPrefix}cc"
  ];

  env = {
    LOCATE_TARGET = "bin.unix";
    # Jam uses c89 conventions
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-std=c89";
  };

  enableParallelBuilding = true;

  strictDeps = true;

  # Jambase expects ar to have flags.
  preConfigure = ''
    export AR="$AR rc"
  '';

  # When cross-compiling, we need to set the preprocessor macros
  # OSMAJOR/OSMINOR/OSPLAT to the values from the target platform, not the host
  # platform. This looks a little ridiculous because the vast majority of build
  # tools don't embed target-specific information into their binary, but in this
  # case we behave more like a compiler than a make(1)-alike.
  postPatch =
    ''
      substituteInPlace Jamfile \
        --replace "strip" "${stdenv.cc.targetPrefix}strip"
    ''
    + lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
      cat >>jam.h <<EOF
      #undef OSMAJOR
      #undef OSMINOR
      #undef OSPLAT
      $(
         ${pkgsBuildTarget.targetPackages.stdenv.cc}/bin/${pkgsBuildTarget.targetPackages.stdenv.cc.targetPrefix}cc -E -dM jam.h | grep -E '^#define (OSMAJOR|OSMINOR|OSPLAT) '
      )
      EOF
    '';

  buildPhase = ''
    runHook preBuild
    make $makeFlags jam0
    ./jam0 -j$NIX_BUILD_CORES -sCC=${buildPackages.stdenv.cc.targetPrefix}cc jambase.c
    ./jam0 -j$NIX_BUILD_CORES
    runHook postBuild
  '';

  # The configure script does not recognize --docdir; because of it, the outputs
  # can't be split
  installPhase = ''
    runHook preInstall

    installBin bin.unix/jam
    install -Dm644 -t ''${!outputDoc}/share/doc/jam-${finalAttrs.version}/ *.html

    runHook postInstall
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "jam -v";
    };
  };

  meta = {
    homepage = "https://freetype.org/jam/";
    description = "FreeType's enhanced, backwards-compatible Jam clone";
    license = lib.licenses.free;
    mainProgram = "jam";
    maintainers = with lib.maintainers; [
      impl
      AndersonTorres
    ];
    platforms = lib.platforms.unix;
  };
})
