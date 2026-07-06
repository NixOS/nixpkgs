{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  makeWrapper,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gitify";
  version = "6.20.0";

  src = fetchFromGitHub {
    owner = "gitify-app";
    repo = "gitify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zKvI9uwKiKKbHTzM/LIhCzUCcM104UNReRJb51iQonc=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    copyDesktopItems
    imagemagick
    makeWrapper
  ];

  strictDeps = true;
  __structuredAttrs = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-KjRcUVeByCXetX7skJoxt6LU6EZcOG+5U2y3sr3XP7A=";
  };

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  postPatch = ''
    substituteInPlace electron-builder.js \
      --replace-fail "'Adam Setch (5KD23H9729)'" "null" \
      --replace-fail "'scripts/afterSign.js'" "null"

    # With a nixpkgs electron wrapper, app.isPackaged always returns false,
    # so isDevMode() is always true. This causes the config.ts getter for
    # indexHtml to return VITE_DEV_SERVER_URL (which is empty) instead of the
    # packaged file:// URL, resulting in a blank white window.
    # Patch isDevMode() to false so the file:// path is always used.
    substituteInPlace src/main/config.ts \
      --replace-fail "isDevMode()" "false"

    # Disable auto-updater; updates are handled via nixpkgs.
    substituteInPlace src/main/updater.ts \
      --replace-fail "if (!this.menubar.app.isPackaged)" "if (true)"
  '';

  buildPhase = ''
    runHook preBuild

    # electronDist needs to be modifiable on Darwin
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    pnpm build
    pnpm exec electron-builder \
        --config electron-builder.js \
        --dir \
        -c.electronDist=electron-dist \
        -c.electronVersion="${electron.version}" \

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r dist/mac*/Gitify.app $out/Applications
          makeWrapper $out/Applications/Gitify.app/Contents/MacOS/gitify $out/bin/gitify
        ''
      else
        ''
          mkdir -p $out/share/gitify
          cp -r dist/*-unpacked/{locales,resources{,.pak}} $out/share/gitify

          mkdir -p $out/share/icons/hicolor/256x256/apps
          magick assets/images/app-icon.ico $out/share/icons/hicolor/256x256/apps/gitify.png

          makeWrapper ${lib.getExe electron} $out/bin/gitify \
              --add-flags $out/share/gitify/resources/app.asar \
              --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
              --inherit-argv0
        ''
    }

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "gitify";
      desktopName = "Gitify";
      exec = "gitify %U";
      icon = "gitify";
      comment = "GitHub notifications on your menu bar";
      categories = [ "Development" ];
      startupWMClass = "Gitify";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitify.io/";
    changelog = "https://github.com/gitify-app/gitify/releases/tag/v${finalAttrs.version}";
    description = "GitHub notifications on your menu bar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pineapplehunter ];
    platforms = lib.platforms.all;
  };
})
