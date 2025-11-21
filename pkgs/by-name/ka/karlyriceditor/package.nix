{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,
  ffmpeg_4,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "karlyriceditor";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = "karlyriceditor";
    rev = finalAttrs.version;
    hash = "sha256-eW5sO1gjuwIighnlylJQd9QC+07s1MZX/oPyaHIi/Qs=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    qt6.qmake
    pkg-config
  ];

  buildInputs = [
    ffmpeg_4
    qt6.qtmultimedia
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/karlyriceditor $out/bin/karlyriceditor
    install -Dm644 packages/karlyriceditor.desktop $out/share/applications/karlyriceditor.desktop
    install -Dm644 packages/karlyriceditor.png $out/share/pixmaps/karlyriceditor.png

    substituteInPlace $out/share/applications/karlyriceditor.desktop \
      --replace-fail 'Icon=/usr/share/pixmaps/karlyriceditor.png' 'Icon=karlyriceditor'

    runHook postInstall
  '';

  meta = {
    description = "Edit and synchronize lyrics with karaoke songs in various formats";
    homepage = "https://github.com/gyunaev/karlyriceditor";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      DPDmancul
    ];
    mainProgram = "karlyricseditor";
    platforms = lib.platforms.linux;
  };
})
