{
  electron_44,
  fetchFromGitHub,
  nix-update-script,
  imagemagick,
  lib,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "folo";

  version = "1.18.0";

  src = fetchFromGitHub {
    owner = "RSSNext";
    repo = "Folo";
    tag = "desktop/v${finalAttrs.version}";
    hash = "sha256-7fscXgNqp/R6dyKgn1kyhqtjWVTh5Z0wx1w4Ne5g9F4=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_12
    makeWrapper
    imagemagick
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmInstallFlags
      ;
    pnpm = pnpm_12;
    fetcherVersion = 5;
    hash = "sha256-x2YZ9vEl1n1p9BeN7vfCuWaviLN5NmD1ooAcqKSt6lg=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # This environment variables inject the production Vite config at build time.
    # Copy from:
    # 1. https://github.com/RSSNext/Folo/blob/v0.4.6/.github/workflows/build-desktop.yml#L27
    # 2. And logs in the corresponding GitHub Actions: https://github.com/RSSNext/Folo/actions/workflows/build-desktop.yml
    VITE_WEB_URL = "https://app.folo.is";
    VITE_API_URL = "https://api.folo.is";
    VITE_SENTRY_DSN = "https://e5bccf7428aa4e881ed5cb713fdff181@o4507542488023040.ingest.us.sentry.io/4507570439979008";
    VITE_OPENPANEL_CLIENT_ID = "0e477ab4-d92d-4d6e-b889-b09d86ab908e";
    VITE_OPENPANEL_API_URL = "https://openpanel.follow.is/api";
    VITE_FIREBASE_CONFIG = builtins.toJSON {
      apiKey = "AIzaSyDuM93019tp8VI7wsszJv8ChOs7b1EE5Hk";
      authDomain = "follow-428106.firebaseapp.com";
      projectId = "follow-428106";
      storageBucket = "follow-428106.appspot.com";
      messagingSenderId = "194977404578";
      appId = "1:194977404578:web:1920bb0c9ea5e2373669fb";
      measurementId = "G-SJE57D4F14";
    };
  };

  dontCheckForBrokenSymlinks = true;

  # Several build scripts import transitive dependencies directly (e.g.
  # ast-kit from unplugin-ast).
  pnpmInstallFlags = [ "--shamefully-hoist" ];

  postPatch = ''
    # pnpm verifies node_modules before every `pnpm run` which conflicts
    # with --shamefully-hoist
    echo 'verifyDepsBeforeRun: false' >> pnpm-workspace.yaml
  '';

  desktopItem = makeDesktopItem {
    name = "folo";
    desktopName = "Folo";
    comment = "Next generation information browser";
    icon = "follow";
    exec = "follow %u";
    categories = [ "Utility" ];
    mimeTypes = [
      "x-scheme-handler/folo"
      "x-scheme-handler/follow"
    ];
  };

  icon = finalAttrs.src + "/apps/desktop/resources/icon.png";

  buildPhase = ''
    runHook preBuild

    pnpm run build:packages

    # Build desktop app.
    cd apps/desktop
    pnpm run build:electron-vite
    cd ../..

    # Reuse the prefetched store for the production dependency tree.
    CI=true pnpm install --offline --frozen-lockfile --ignore-scripts --prod
    # Clean up broken symlinks left behind when removing dev dependencies.
    [ -d node_modules/.bin ] && find node_modules/.bin -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,follow}
    cp -r . $out/share/follow
    rm -rf $out/share/follow/{.vscode,.github}

    makeWrapper "${electron_44}/bin/electron" "$out/bin/follow" \
      --inherit-argv0 \
      --set CHROME_DESKTOP folo.desktop \
      --add-flags $out/share/follow/apps/desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D "${finalAttrs.desktopItem}/share/applications/"* \
        -t $out/share/applications/

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -background none -resize "$size"x"$size" ${finalAttrs.icon} $out/share/icons/hicolor/"$size"x"$size"/apps/follow.png
    done

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^desktop/v([0-9]+\\.[0-9]+\\.[0-9]+)$"
    ];
  };

  meta = {
    description = "Next generation information browser";
    homepage = "https://github.com/RSSNext/Folo";
    changelog = "https://github.com/RSSNext/Folo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      amadejkastelic
      iosmanthus
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "follow";
  };
})
