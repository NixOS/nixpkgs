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
  bc,
}:

stdenv.mkDerivation {
  pname = "ioquake3";
  version = "unstable-2025-03-08";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "c9697a01040629579d150c4b4c9f73a895bd584f";
    sha256 = "sha256-3m9K9H3OPlMdJIeWnCo/bLcBFnjZbdzegqPJV6kwRwk=";
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
        "CLIENT_LIBS += -L${lib.getDev SDL2}/lib -lSDL2" \
      --replace-fail \
        "RENDERER_LIBS += -framework SDL2" \
        "RENDERER_LIBS += -L${lib.getDev SDL2}/lib -lSDL2" \
      --replace-fail \
        "-I/System/Library/Frameworks/OpenAL.framework/Headers" \
        "-I${lib.getDev openal}/include/AL" \
      --replace-fail \
        "CLIENT_LIBS += -framework OpenAL" \
        "CLIENT_LIBS += -L${lib.getDev openal}/lib -lopenal" \
      --replace-fail \
        "TOOLS_CC = gcc" \
        "TOOLS_CC = clang"
  '';

  postBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
    echo "Building Application Bundle for Darwin / MacOS"
    ./make-macosx.sh ${stdenv.hostPlatform.darwinArch}
  '';

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)/share/ioquake3" ];

  postInstall =
    ''
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
      comment = "A fast-paced 3D first-person shooter, a community effort to continue supporting/developing id's Quake III Arena";
      desktopName = "ioquake3";
      categories = [
        "Game"
        "ActionGame"
      ];
    })
  ];

  meta = {
    homepage = "https://ioquake3.org/";
    description = "Fast-paced 3D first-person shooter, a community effort to continue supporting/developing id's Quake III Arena";
    license = lib.licenses.gpl2Plus;
    mainProgram = "ioquake3";
    maintainers = with lib.maintainers; [
      abbradar
      drupol
      rvolosatovs
    ];
    platforms = lib.platforms.unix;
  };
}
