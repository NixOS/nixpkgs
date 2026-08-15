{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  electron_43,
  makeDesktopItem,
  copyDesktopItems,
  imagemagick,
  makeWrapper,
  cacert,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
  electron = electron_43;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gitify";
  version = "7.3.3";

  src = fetchFromGitHub {
    owner = "gitify-app";
    repo = "gitify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kr4+U6UD/cfbAzIZ8GrPgxGmV8ktENxd9o2/x3C4v+c=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
    copyDesktopItems
    imagemagick
    makeWrapper
    cacert
  ];

  strictDeps = true;
  __structuredAttrs = true;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-Uxta96e9t0jOfsgR82fMuzc1V5KC0t1n2TJ90qv73wg=";
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
