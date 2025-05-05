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
}:

stdenv.mkDerivation {
  pname = "ioquake3";
  version = "0-unstable-2025-04-25";

  src = fetchFromGitHub {
    owner = "ioquake";
    repo = "ioq3";
    rev = "10afd421f23876e03535bb1958eae8b76371565d";
    hash = "sha256-5ByaIjmyndiliU5qnt62mj2CFByVv4M4+d3KBAgysck=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    makeBinaryWrapper
    pkg-config
    which
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

  installTargets = [ "copyfiles" ];

  installFlags = [ "COPYDIR=$(out)/share/ioquake3" ];

  postInstall = ''
    install -Dm644 misc/quake3.svg $out/share/icons/hicolor/scalable/apps/ioquake3.svg

    makeWrapper $out/share/ioquake3/ioquake3.* $out/bin/ioquake3
    makeWrapper $out/share/ioquake3/ioq3ded.* $out/bin/ioq3ded
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

  passthru.updateScript = unstableGitUpdater { };

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
    platforms = lib.platforms.linux;
  };
}
