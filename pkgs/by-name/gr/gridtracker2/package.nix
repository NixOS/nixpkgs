{
  lib,
  stdenv,
  copyDesktopItems,
  buildNpmPackage,
  electron,
  fetchFromGitLab,
  makeBinaryWrapper,
  makeDesktopItem,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "gridtracker2";
  version = "2.260330.2";

  src = fetchFromGitLab {
    owner = "gridtracker.org";
    repo = "gridtracker2";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4FQFTVVICkjb0hjFo3i2c0TRR0eefpzt5E2yT/FxNZo=";
  };

  npmDepsHash = "sha256-dJmrNP2AwIaQaCq0guG+OTogfcL8f97MAp6N7HAw5z8=";

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  makeCacheWritable = true;

  desktopItems = [
    (makeDesktopItem {
      name = "GridTracker2";
      desktopName = "GridTracker2";
      exec = "gridtracker2 %U";
      terminal = false;
      type = "Application";
      icon = "gridtracker2";
      startupWMClass = "GridTracker2";
      comment = "A warehouse of amateur radio information";
      categories = [
        "HamRadio"
        "Network"
      ];
    })
  ];

  buildPhase = ''
    runHook preBuild
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null # Disable code signing on macOS
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}
  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dvm644 -t "$out/share/gridtracker2/resources" \
     ./dist/linux*/resources/*
    install -Dvm644 -t "$out/share/gridtracker2/locales" \
      ./dist/linux*/locales/*
    install -Dvm644 ./resources/icon.png \
      "$out/share/icons/hicolor/256x256/apps/gridtracker2.png"

    makeWrapper ${lib.getExe electron} $out/bin/gridtracker2 \
      --add-flags $out/share/gridtracker2/resources/app.asar \
      --add-flags "--no-sandbox --disable-gpu-sandbox" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    cp -r dist/mac*/GridTracker2.app $out/Applications
    ln -s $out/Applications/GridTracker2.app/Contents/MacOS/GridTracker2 $out/bin/gridtracker2
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Warehouse of amateur radio information";
    homepage = "https://gridtracker.org/";
    license = lib.licenses.bsd3;
    platforms = electron.meta.platforms;
    maintainers = with lib.maintainers; [ Cryolitia ];
    mainProgram = "gridtracker2";
  };
})
