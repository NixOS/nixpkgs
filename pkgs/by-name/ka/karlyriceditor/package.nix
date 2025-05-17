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
  version = "3.3";

  src = fetchFromGitHub {
    owner = "gyunaev";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    sha256 = "sha256-i4uZtHxnreow7a5ZX6WCXMUSwgkUJS/1oDCJOgfFjHw=";
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

  installPhase =
    if stdenv.hostPlatform.isDarwin then
      ''
        mkdir -p $out/Applications
        mv karlyriceditor.app $out/Applications
      ''
    else
      ''
        install -Dm755 bin/karlyriceditor $out/bin/karlyriceditor
        install -Dm644 packages/karlyriceditor.desktop $out/share/applications/karlyriceditor.desktop
        install -Dm644 packages/karlyriceditor.png $out/share/pixmaps/karlyriceditor.png
      '';

  meta = with lib; {
    description = "Edit and synchronize lyrics with karaoke songs in various formats";
    homepage = "https://github.com/gyunaev/karlyriceditor";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      DPDmancul
    ];
    mainProgram = "karlyricseditor";
    platforms = platforms.unix;
  };
})
