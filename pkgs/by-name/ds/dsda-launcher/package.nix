{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  wrapGAppsHook3,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "dsda-launcher";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "Pedro-Beirao";
    repo = "dsda-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lk4MtITvJKh6p3x8KhJl3Yqs4VJjSr2aJTIaGmyABpQ=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    wrapGAppsHook3
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p "./src/build"
    cd "./src/build"
    qmake6 ..
    make
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp ./dsda-launcher $out/bin
    install -Dm444 ../../dist/linux/eu.pedro_beirao.dsda-launcher.desktop $out/share/applications/dsda-launcher.desktop
    install -Dm444 ../../dist/icons/eu.pedro_beirao.dsda-launcher.svg $out/share/icons/hicolor/scalable/apps/eu.pedro_beirao.dsda-launcher.svg
    runHook postInstall
  '';

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=(''${gappsWrapperArgs[@]})
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/Pedro-Beirao/dsda-launcher";
    description = "Launcher GUI for the dsda-doom source port";
    mainProgram = "dsda-launcher";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Gliczy ];
  };
})
