{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  copyDesktopItems,
  makeWrapper,
  python3,
  zip,
  electron,
  makeDesktopItem,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "cheating-daddy";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "sohzm";
    repo = "cheating-daddy";
    tag = finalAttrs.version;
    hash = "sha256-w1Kd9V9MQvsWiVHr9pRPVLkds+Aj/dsZg6Xvj0vWWVg=";
  };

  npmDepsHash = "sha256-fMvzHrljOm43Dj0uJcqCj6QWd6qosARainhW9WSE348=";

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    (python3.withPackages (ps: with ps; [ setuptools ]))
    zip
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  makeCacheWritable = true;

  preBuild = ''
    cp --recursive --no-preserve=mode ${electron.dist} electron-dist
    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd
    rm --recursive electron-dist
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "\"$(pwd)/electron.zip\""
  '';

  buildPhase = ''
    runHook preBuild

    npm run package

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cheating-daddy";
      desktopName = "Cheating Daddy";
      genericName = "AI Assistant";
      comment = "AI assistant for interviews and learning";
      exec = "cheating-daddy";
      terminal = false;
      icon = "cheating-daddy";
      categories = [
        "Development"
        "Education"
      ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/cheating-daddy
    cp --recursive out/*/{locales,resources{,.pak}} $out/share/cheating-daddy
    makeWrapper ${lib.getExe electron} $out/bin/cheating-daddy \
      --add-flags $out/share/cheating-daddy/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --inherit-argv0
    install -D --mode=0644 src/assets/logo.png $out/share/icons/hicolor/512x512/apps/cheating-daddy.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/sohzm/cheating-daddy/releases/tag/${finalAttrs.src.tag}";
    description = "Real-time AI assistant that provides contextual help during video calls, interviews, presentations, and meetings using screen capture and audio analysis";
    homepage = "https://github.com/sohzm/cheating-daddy";
    license = lib.licenses.gpl3Only;
    mainProgram = "cheating-daddy";
    maintainers = with lib.maintainers; [ kyehn ];
    platforms = lib.platforms.linux;
  };
})
