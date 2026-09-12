{
  lib,
  buildNpmPackage,
  copyDesktopItems,
  electron_43,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "fantasy-map-generator";
  version = "1.152.0";

  src = fetchFromGitHub {
    owner = "Azgaar";
    repo = "Fantasy-Map-Generator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3dtgol2NELTneebshnjFqBZhNt2XXS0i/xbEVnJXG1g=";
  };

  npmDepsHash = "sha256-RshRYAUCxONTfN5p7OZX1HUFqV2A2VItVCQQRPxKj/w=";

  # `prepare` installs git hooks, electron's postinstall downloads a browser
  # that is not used, and electron-winstaller only supports Windows
  npmFlags = [ "--ignore-scripts" ];
  dontNpmBuild = true;

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  # typechecks and bundles the main and renderer processes into dist-electron/,
  # stopping short of electron-builder, which would download prebuilt binaries
  buildPhase = ''
    runHook preBuild
    npm run electron build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fantasy-map-generator
    cp -r dist-electron $out/share/fantasy-map-generator/
    cp package.json $out/share/fantasy-map-generator/

    install -Dm644 build/icon.png \
      $out/share/icons/hicolor/512x512/apps/fantasy-map-generator.png

    makeWrapper ${lib.getExe electron_43} $out/bin/fantasy-map-generator \
      --add-flags $out/share/fantasy-map-generator \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fantasy-map-generator";
      exec = "fantasy-map-generator %U";
      icon = "fantasy-map-generator";
      desktopName = "Fantasy Map Generator";
      genericName = "Fantasy Map Editor";
      comment = "Generate and edit fantasy maps";
      categories = [
        "Graphics"
        "Education"
      ];
      keywords = [
        "map"
        "fantasy"
        "cartography"
        "worldbuilding"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web application that helps fantasy writers, game masters and cartographers create and edit fantasy maps";
    homepage = "https://github.com/Azgaar/Fantasy-Map-Generator";
    changelog = "https://github.com/Azgaar/Fantasy-Map-Generator/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ barrulus ];
    mainProgram = "fantasy-map-generator";
    # the wrapper starts a bare Electron, which is not a macOS .app bundle
    platforms = lib.platforms.linux;
  };
})
