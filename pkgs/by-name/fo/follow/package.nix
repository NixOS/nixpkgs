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

  version = "0.0.1-alpha.17";

  src = fetchFromGitHub {
    owner = "RSSNext";
    repo = "Follow";
    rev = "v${version}";
    hash = "sha256-amW+jpJ2E7muKwiWbblONRFzH849js2SaT+poUWQWZI=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
    makeWrapper
    imagemagick
  ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-JFAONU1C8pB2Hu4PJqqdqcXk9Ec+iPiAL8J+dk4oPj0=";
  };

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

    # This environment variables inject the production Vite config at build time.
    # Copy from:
    # 1. https://github.com/RSSNext/Follow/blob/0745ac07dd2a4a34e4251c034678ace15c302697/.github/workflows/build.yml#L18
    # 2. And logs in the corresponding GitHub Actions: https://github.com/RSSNext/Follow/actions/workflows/build.yml
    VITE_WEB_URL = "https://app.follow.is";
    VITE_API_URL = "https://api.follow.is";
    VITE_IMGPROXY_URL = "https://thumbor.follow.is";
    VITE_SENTRY_DSN = "https://e5bccf7428aa4e881ed5cb713fdff181@o4507542488023040.ingest.us.sentry.io/4507570439979008";
    VITE_BUILD_TYPE = "production";
    VITE_POSTHOG_KEY = "phc_EZGEvBt830JgBHTiwpHqJAEbWnbv63m5UpreojwEWNL";
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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime}}"

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
