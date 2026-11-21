{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  copyDesktopItems,
  makeBinaryWrapper,
  SDL2,
  libGL,
  openal,
  curl,
  speex,
  opusfile,
  libogg,
  libvorbis,
  libjpeg,
  makeDesktopItem,
  freetype,
  unstableGitUpdater,
  bc,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ioquake3";
  version = "0-unstable-2026-10-12";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "87a99d18206e878a20289f05ac3c16005dcae5c3";
    hash = "sha256-C4ExSNdyWb1SyHjNygiTXatZjQ9KoeSwUS6nZx91Xms=";
  };

  nativeBuildInputs = [
    bc
    cmake
    copyDesktopItems
    makeBinaryWrapper
    pkg-config
    which
  ];

  buildInputs = [
    SDL2
    curl
    freetype
    libGL
    libjpeg
    libogg
    libvorbis
    openal
    opusfile
    speex
  ];

  enableParallelBuilding = true;

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=${placeholder "out"}/share/ioquake3"
    (lib.cmakeBool "USE_INTERNAL_LIBS" true)
  ];

  postInstall = ''
    install -Dm644 ${finalAttrs.src}/misc/quake3.svg \
      $out/share/icons/hicolor/scalable/apps/ioquake3.svg
    makeWrapper $out/share/ioquake3/ioq3ded $out/bin/ioq3ded
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper $out/share/ioquake3/ioquake3 $out/bin/ioquake3
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv $out/share/ioquake3/ioquake3.app $out/Applications/
    mkdir -p $out/bin
    makeWrapper $out/Applications/ioquake3.app/Contents/MacOS/ioquake3 $out/bin/ioquake3
    makeWrapper $out/share/ioquake3/ioq3ded $out/Applications/ioquake3.app/Contents/MacOS/ioq3ded
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "IOQuake3";
      exec = "ioquake3";
      icon = "ioquake3";
      comment = finalAttrs.meta.description;
      desktopName = "ioquake3";
      categories = [
        "Game"
        "ActionGame"
      ];
    })
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://ioquake3.org/";
    description = "Fast-paced 3D first-person shooter, a community effort to continue supporting/developing id's Quake III Arena";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ioquake3";
    maintainers = with lib.maintainers; [
      rvolosatovs
    ];
    platforms = lib.platforms.unix;
  };
})
