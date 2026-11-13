{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ctestCheckHook,
  pkg-config,
  qt6,
  libjpeg_turbo,
  libpulseaudio,
  ffmpeg,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "monologue";
  version = "0.4.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "omacom";
    repo = "monologue";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YksthuX2lXMYiYofvrlPElbiBB5p7g4eEEby8q13WLo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtwayland
    libjpeg_turbo
    libpulseaudio
  ];

  nativeCheckInputs = [
    ctestCheckHook
    ffmpeg
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export HOME=$(mktemp -d)
    export QT_PLUGIN_PATH="${qt6.qtbase}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtPluginPrefix}:${qt6.qtdeclarative}/${qt6.qtbase.qtPluginPrefix}"
    export QML2_IMPORT_PATH="${qt6.qtdeclarative}/${qt6.qtbase.qtQmlPrefix}:${qt6.qtmultimedia}/${qt6.qtbase.qtQmlPrefix}"
  '';

  # CMakeLists.txt has no install rules; this mirrors upstream's PKGBUILD.
  installPhase = ''
    runHook preInstall
    install -Dm755 monologue "$out/bin/monologue"
    install -Dm644 ../pkgbuild/monologue.svg "$out/share/icons/hicolor/scalable/apps/monologue.svg"
    install -Dm644 ../pkgbuild/monologue.desktop "$out/share/applications/monologue.desktop"
    runHook postInstall
  '';

  # Recording, editing and saving shell out to ffmpeg and ffprobe.
  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Minimal webcam and microphone recorder with a built-in trimming editor";
    homepage = "https://github.com/omacom/monologue";
    changelog = "https://github.com/omacom/monologue/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux;
    mainProgram = "monologue";
  };
})
