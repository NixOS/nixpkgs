{
  electron,
  fetchFromGitHub,
  imagemagick,
  lib,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  pnpm_10,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "folo";

  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "RSSNext";
    repo = "Folo";
    tag = "v${version}";
    hash = "sha256-huVk5KcsepDwtdWMm9pvn31GE1felbH1pR3mGqlSWRs=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10.configHook
    makeWrapper
    imagemagick
  ];

  pnpmDeps = pnpm_10.fetchDeps {
    inherit pname version src;
    fetcherVersion = 1;
    hash = "sha256-6I10NSmTDd/wmL/HfAgLH+G2MDfuPmrTePNDDy08nRA=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # This environment variables inject the production Vite config at build time.
    # Copy from:
    # 1. https://github.com/RSSNext/Folo/blob/v0.4.6/.github/workflows/build-desktop.yml#L27
    # 2. And logs in the corresponding GitHub Actions: https://github.com/RSSNext/Folo/actions/workflows/build-desktop.yml
    VITE_WEB_URL = "https://app.follow.is";
    VITE_API_URL = "https://api.follow.is";
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

  desktopItem = makeDesktopItem {
    name = "folo";
    desktopName = "Folo";
    comment = "Next generation information browser";
    icon = "follow";
    exec = "follow";
    categories = [ "Utility" ];
    mimeTypes = [ "x-scheme-handler/follow" ];
  };

  icon = src + "/apps/desktop/resources/icon.png";

  buildPhase = ''
    runHook preBuild

    pnpm run build:packages

    # Build desktop app.
    cd apps/desktop
    pnpm --offline --no-inline-css build:electron-vite
    cd ../..

    # Remove dev dependencies.
    CI=true pnpm --ignore-scripts prune --prod
    # Clean up broken symlinks left behind by `pnpm prune`
    find node_modules/.bin -xtype l -delete

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/{applications,follow}
    cp -r . $out/share/follow
    rm -rf $out/share/follow/{.vscode,.github}

    makeWrapper "${electron}/bin/electron" "$out/bin/follow" \
      --inherit-argv0 \
      --add-flags $out/share/follow/apps/desktop \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    install -m 444 -D "${desktopItem}/share/applications/"* \
        -t $out/share/applications/

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -background none -resize "$size"x"$size" ${icon} $out/share/icons/hicolor/"$size"x"$size"/apps/follow.png
    done

    runHook postInstall
  '';

  meta = {
    description = "Next generation information browser";
    homepage = "https://github.com/RSSNext/Folo";
    changelog = "https://github.com/RSSNext/Folo/releases/tag/${src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iosmanthus ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "follow";
  };
}
