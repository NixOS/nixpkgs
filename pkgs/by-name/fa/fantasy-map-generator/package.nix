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
  version = "1.153.0";

  src = fetchFromGitHub {
    owner = "Azgaar";
    repo = "Fantasy-Map-Generator";
    # Upstream tagged this source as 1.153.1 without bumping the app version.
    tag = "1.153.1";
    hash = "sha256-XCz1j/SfK2SNck5aak7QbMOLcLPoh84GrqaMDPgIihc=";
  };

  npmDepsHash = "sha256-Hr/nk0CItMe/O53ryZ16pQOZJKdUWCvUZVXZxO3xbQo=";

  # `prepare` installs git hooks, electron's postinstall downloads a browser
  # that is not used, and electron-winstaller only supports Windows
  npmFlags = [ "--ignore-scripts" ];

  __structuredAttrs = true;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
  ];

  # typechecks and bundles the main and renderer processes into dist-electron/,
  # stopping short of electron-builder, which would download prebuilt binaries
  npmBuildScript = "electron";
  npmBuildFlags = [ "build" ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fantasy-map-generator
    cp -r dist-electron $out/share/fantasy-map-generator/
    cp package.json $out/share/fantasy-map-generator/

    install -Dm644 build/icon.png \
      $out/share/icons/hicolor/512x512/apps/fantasy-map-generator.png

    makeWrapper ${lib.getExe electron_43} $out/bin/fantasy-map-generator \
      --add-flags "--class=fantasy-map-generator" \
      --add-flags $out/share/fantasy-map-generator \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "fantasy-map-generator";
      exec = "fantasy-map-generator";
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
      startupWMClass = "fantasy-map-generator";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Web application that helps fantasy writers, game masters, and cartographers create and edit fantasy maps";
    homepage = "https://github.com/Azgaar/Fantasy-Map-Generator";
    changelog = "https://github.com/Azgaar/Fantasy-Map-Generator/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ barrulus ];
    mainProgram = "fantasy-map-generator";
    # the wrapper starts a bare Electron, which is not a macOS .app bundle
    platforms = lib.platforms.linux;
  };
})
