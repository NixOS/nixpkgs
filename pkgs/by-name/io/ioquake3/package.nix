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
  mumble,
  unstableGitUpdater,
  bc,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ioquake3";
  version = "0-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "3371603c50c51911da6f17aa61ebc547c4e73418";
    hash = "sha256-QfCO6qdLNxG/t1l3UbG0lVIDYh3YKuKCDKf6lMj1/B8=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    pkg-config
    which
    bc
  ];

  buildInputs = [
    SDL2
    libGL
    openal
    curl
    speex
    opusfile
    libogg
    libvorbis
    libjpeg
    freetype
    mumble
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    cp ${./Makefile.local} ./Makefile.local
  '';

  preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Makefile \
      --replace-fail \
        "-I/Library/Frameworks/SDL2.framework/Headers" \
        "-I${lib.getDev SDL2}/include/SDL2" \
      --replace-fail \
        "CLIENT_LIBS += -framework SDL2" \
        "CLIENT_LIBS += -L${lib.getLib SDL2}/lib -lSDL2" \
      --replace-fail \
        "RENDERER_LIBS += -framework SDL2" \
        "RENDERER_LIBS += -L${lib.getLib SDL2}/lib -lSDL2" \
      --replace-fail \
        "-I/System/Library/Frameworks/OpenAL.framework/Headers" \
        "-I${lib.getDev openal}/include/AL" \
      --replace-fail \
        "CLIENT_LIBS += -framework OpenAL" \
        "CLIENT_LIBS += -L${lib.getLib openal}/lib -lopenal" \
      --replace-fail \
        "TOOLS_CC = gcc" \
        "TOOLS_CC = clang"
  '';

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    echo "Building Application Bundle for Darwin / macOS"
    # The following script works without extensive patching (see preBuild), as the regular buil already
    # built all the c code and libraries.
    ./make-macosx.sh ${stdenv.hostPlatform.darwinArch}
  '';

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)/share/ioquake3" ];

  postInstall = ''
    install -Dm644 misc/quake3.svg $out/share/icons/hicolor/scalable/apps/ioquake3.svg

    makeWrapper $out/share/ioquake3/ioquake3.* $out/bin/ioquake3
    makeWrapper $out/share/ioquake3/ioq3ded.* $out/bin/ioq3ded
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv build/release-darwin-${stdenv.hostPlatform.darwinArch}/ioquake3.app $out/Applications/
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
