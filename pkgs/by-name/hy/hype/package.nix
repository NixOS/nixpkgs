{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  zlib,
  libwebp,
  source-highlight,
  ffmpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hype";
  version = "0.4.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "hype";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GOhNOPuOf4eXcXUZfylJYccUW7vsifAahqOIBzytZ48=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    qt6.qtdeclarative
    qt6.qtmultimedia
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtimageformats
    qt6.qtsvg
    zlib
    libwebp
  ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      source-highlight
      ffmpeg
    ])
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 hype "$out/bin/hype"
    install -Dm644 LICENSE "$out/share/licenses/hype/LICENSE"
    install -Dm644 pkgbuild/hype.svg \
      "$out/share/icons/hicolor/scalable/apps/hype.svg"
    install -Dm644 pkgbuild/hype.desktop \
      "$out/share/applications/hype.desktop"
    runHook postInstall
  '';

  meta = {
    description = "Markdown presentation compiler and visual slide editor";
    homepage = "https://github.com/omacom/hype";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "hype";
  };
})
