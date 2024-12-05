{
  electron,
  fetchFromGitHub,
  imagemagick,
  lib,
  makeDesktopItem,
  makeWrapper,
  nodejs,
  pnpm,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "follow";

  version = "0.2.0-beta.2";

  src = fetchFromGitHub {
    owner = "RSSNext";
    repo = "Follow";
    rev = "v${version}";
    hash = "sha256-7KSPZj9QG6zksji/eY8jczBDHr/9tStlw26LKVqXTAw=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
    imagemagick
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-FzMjN0rIjYxexf6tix4qi3mnuPkadjKihhN0Pj5y2nU=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # This environment variables inject the production Vite config at build time.
    # Copy from:
    # 1. https://github.com/RSSNext/Follow/blob/v0.2.0-beta.2/.github/workflows/build.yml#L18
    # 2. And logs in the corresponding GitHub Actions: https://github.com/RSSNext/Follow/actions/workflows/build.yml
    VITE_WEB_URL = "https://app.follow.is";
    VITE_API_URL = "https://api.follow.is";
    VITE_IMGPROXY_URL = "https://thumbor.follow.is";
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

  desktopItem = makeDesktopItem {
    name = "follow";
    desktopName = "Follow";
    comment = "Next generation information browser";
    icon = "follow";
    exec = "follow";
    categories = [ "Utility" ];
    mimeTypes = [ "x-scheme-handler/follow" ];
  };

  icon = src + "/resources/icon.png";

  buildPhase = ''
    runHook preBuild

    pnpm --offline electron-vite build
    # Remove dev dependencies.
    pnpm --ignore-scripts prune --prod
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
      --add-flags --disable-gpu-compositing \
      --add-flags $out/share/follow \
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
    homepage = "https://github.com/RSSNext/Follow";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ iosmanthus ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "follow";
  };
}
