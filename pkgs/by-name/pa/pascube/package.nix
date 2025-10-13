{
  autoPatchelfHook,
  copyDesktopItems,
  fetchFromGitHub,
  fpc,
  lazarus-qt6,
  lib,
  libGLU,
  makeDesktopItem,
  nix-update-script,
  qt6Packages,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pascube";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "benjamimgois";
    repo = "pascube";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-djkrMgX3RTTXSLISYpBfdyCIh3/WWODxd473M53iFKE=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    fpc
    lazarus-qt6
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6Packages.libqtpas
    qt6Packages.qtbase
  ];

  runtimeDependencies = [
    libGLU
  ];

  buildPhase = ''
    runHook preBuild
    HOME=$(mktemp -d) lazbuild \
      --lazarusdir=${lazarus-qt6}/share/lazarus \
      --primary-config-path=$out \
      --widgetset=qt6 \
      pascube.lpi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 pascube $out/bin/pascube
    for sz in 128x128 256x256 512x512; do
      install -Dm644 "data/icons/''${sz}/pascube.png" \
        "$out/share/icons/hicolor/''${sz}/apps/pascube.png"
    done
    install -Dm644 "data/skybox.png" "$out/share/pascube/skybox.png"
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "pascube";
      desktopName = "pasCube";
      comment = finalAttrs.meta.description;
      exec = finalAttrs.meta.mainProgram;
      icon = "pascube";
      terminal = false;
      categories = [
        "Graphics"
        "Education"
        "Qt"
      ];
    })
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --set QT_QPA_PLATFORM xcb
    )
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple OpenGL spinning cube written in Pascal";
    homepage = "https://github.com/benjamimgois/pascube";
    changelog = "https://github.com/benjamimgois/pascube/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ RoGreat ];
    mainProgram = "pascube";
    platforms = lib.platforms.linux;
  };
})
