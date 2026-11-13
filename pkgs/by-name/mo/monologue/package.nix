{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  libpulseaudio,
  ffmpeg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monologue";
  version = "0.3.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "monologue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-juzlFfzZ9ZtCKwy8/ckJAOhgN+4NwZ3QyN4Fzr8Vvqs=";
  };

  nativeBuildInputs = [
    qt6.qmake
    qt6.wrapQtAppsHook
    qt6.qtdeclarative
    qt6.qtmultimedia
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    libpulseaudio
  ];

  enableParallelBuilding = true;

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 monologue "$out/bin/monologue"
    install -Dm644 LICENSE "$out/share/licenses/monologue/LICENSE"
    install -Dm644 pkgbuild/monologue.svg \
      "$out/share/icons/hicolor/scalable/apps/monologue.svg"
    install -Dm644 pkgbuild/monologue.desktop \
      "$out/share/applications/monologue.desktop"
    runHook postInstall
  '';

  meta = {
    description = "Minimal webcam and microphone recording desktop application";
    homepage = "https://github.com/omacom/monologue";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "monologue";
  };
})
