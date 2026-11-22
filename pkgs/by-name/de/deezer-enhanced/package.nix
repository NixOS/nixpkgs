{
  lib,
  buildNpmPackage,
  fetchurl,
  fetchFromGitHub,
  nodejs_22,
  electron_43,
  makeWrapper,
  makeDesktopItem,
  copyDesktopItems,
  zip,
}:

let
  # Electron 43.8.3 at the time of writing. Pinned to the 43.x branch so that
  # patch releases are picked up automatically; bump the branch deliberately.
  # Upstream still targets Electron 37, but 43 works with
  # fix-window-sizing.patch.
  electron = electron_43;
  electronVersion = electron.version;

  # The upstream dependency points to a fork (2.1.6) that is not published to
  # npm. The published 2.1.5 tarball has the same runtime code; the fork only
  # adds type declarations and a version bump. Using the prebuilt tarball
  # avoids a second npm build and a generated lockfile.
  mpris-service-tarball = fetchurl {
    url = "https://registry.npmjs.org/@jellybrick/mpris-service/-/mpris-service-2.1.5.tgz";
    hash = "sha256-GBAWxhT8YlldYE0zbNtDxAZF18xmo1rK9WLJryYXem4=";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "deezer-enhanced";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "duzda";
    repo = "deezer-enhanced";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ohlmcg0qi/X/XPUfOB8J+xJ3okRUgYSUOJbs2x+TpeE=";
  };

  patches = [
    ./disable-unused-makers.patch

    # Electron 38+ reports the outer window bounds from BaseWindow.getBounds(),
    # which crops the Deezer playback controls. Upstream works around it by
    # staying on Electron 37, which is no longer available in nixpkgs.
    ./fix-window-sizing.patch
  ];

  npmDepsHash = "sha256-KPCVxLUPyxHDybOGMoVAutAb3UjWdM6hRoEZ2PPtN48=";
  makeCacheWritable = true;
  # register-scheme is an optional, Windows-only dependency pulled in by
  # discord-rpc. It has an install script but no lockfile.
  forceGitDeps = true;
  npmBuildScript = "package";
  npmRebuildFlags = [ "--ignore-scripts" ];
  nodejs = nodejs_22;

  nativeBuildInputs = [
    copyDesktopItems
    makeWrapper
    zip
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    CI = "1";
  };

  postConfigure = ''
    # electron-forge determines the Electron version from node_modules. Make it
    # use the pinned Electron from nixpkgs instead.
    substituteInPlace node_modules/@electron-forge/core-utils/dist/electron-version.js \
      --replace-fail "return version" "return '${electronVersion}'"

    # Create the Electron archive used by @electron/packager.
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pushd electron-dist
    zip -0Xqr ../electron.zip .
    popd

    rm -r electron-dist

    # Force @electron/packager to use our Electron instead of downloading it.
    substituteInPlace node_modules/@electron/packager/dist/packager.js \
      --replace-fail "await this.getElectronZipPath(downloadOpts)" "'$(pwd)/electron.zip'"

    # Native modules are not required by this application, and rebuilding them
    # would need to download Electron headers.
    substituteInPlace forge.config.ts \
      --replace-fail "rebuildConfig: {}," "rebuildConfig: { onlyModules: [] },"

    # Use the published prebuilt mpris-service package.
    rm -rf node_modules/@jellybrick/mpris-service
    mkdir -p node_modules/@jellybrick/mpris-service
    tar -xzf ${mpris-service-tarball} \
      -C node_modules/@jellybrick/mpris-service --strip-components=1
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/deezer-enhanced
    cp -r out/*/resources $out/share/deezer-enhanced/

    install -Dm644 build/icon.svg \
      $out/share/icons/hicolor/scalable/apps/deezer-enhanced.svg
    install -Dm644 build/icons/512x512.png \
      $out/share/icons/hicolor/512x512/apps/deezer-enhanced.png

    makeWrapper ${lib.getExe electron} $out/bin/deezer-enhanced \
      --run "cd $out/share/deezer-enhanced/resources" \
      --add-flags "$out/share/deezer-enhanced/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "deezer-enhanced";
      desktopName = "Deezer Enhanced";
      comment = finalAttrs.meta.description;
      exec = "deezer-enhanced %U";
      icon = "deezer-enhanced";
      categories = [
        "Audio"
        "AudioVideo"
      ];
      mimeTypes = [ "x-scheme-handler/deezer" ];
      startupNotify = true;
      startupWMClass = "deezer-enhanced";
    })
  ];

  meta = {
    description = "Unofficial application for Deezer with enhanced features";
    homepage = "https://github.com/duzda/deezer-enhanced";
    changelog = "https://github.com/duzda/deezer-enhanced/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "deezer-enhanced";
    maintainers = with lib.maintainers; [ minegameYTB ];
    platforms = lib.intersectLists lib.platforms.linux electron.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
