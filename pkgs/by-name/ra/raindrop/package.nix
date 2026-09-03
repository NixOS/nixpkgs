{
  asar,
  buildNpmPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  lib,
  makeDesktopItem,
  makeWrapper,
}:
let
  sources = lib.importJSON ./sources.json;
  inherit (sources) version;

  webapp = buildNpmPackage {
    pname = "raindrop-webapp";
    inherit version;

    src = fetchFromGitHub {
      owner = "raindropio";
      repo = "app";
      rev = sources.webappRev;
      hash = sources.webappHash;
    };

    npmDepsHash = sources.webappNpmHash;

    npmBuildScript = "build:electron";

    # The post-install script for @sentry/cli tries to download a native binary
    # which won't work in the Nix sandbox, and we don't want the telemetry anyway.
    env.SENTRYCLI_SKIP_DOWNLOAD = "1";

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r dist/electron/prod/* $out/
      runHook postInstall
    '';
  };
in
buildNpmPackage {
  pname = "raindrop";
  inherit version;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "raindropio";
    repo = "desktop";
    rev = sources.desktopRev;
    hash = sources.desktopHash;
  };

  npmDepsHash = sources.desktopNpmHash;

  makeCacheWritable = true;
  dontNpmBuild = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  # The "0.0.0" placeholder is normally replaced by electron-builder at
  # release time. We skip that process, so we have to patch it ourselves.
  postPatch = ''
    substituteInPlace package.json \
      --replace-fail '"version": "0.0.0"' '"version": "${version}"'
  '';

  nativeBuildInputs = [
    asar
    copyDesktopItems
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/raindrop

    # The path must match how the desktop app references the webapp submodule.
    mkdir -p app/webapp/dist/electron/prod
    cp package.json app/
    cp -r src app/
    cp -r ${webapp}/* app/webapp/dist/electron/prod/
    cp -r node_modules app/

    # --ignore-scripts prevents post-install hooks from running (and failing).
    npm prune --prefix app --omit=dev --ignore-scripts 2>/dev/null || true

    asar pack app $out/share/raindrop/app.asar

    for size in 16 32 48 64 128 256 512; do
      install -Dm 644 "build/linux/''${size}x''${size}.png" \
        "$out/share/icons/hicolor/''${size}x''${size}/apps/raindrop.png"
    done

    makeWrapper ${lib.getExe electron} $out/bin/raindrop \
      --add-flags $out/share/raindrop/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "raindrop";
      icon = "raindrop";
      exec = "raindrop %U";
      desktopName = "Raindrop.io";
      genericName = "Bookmark Manager";
      comment = "All-in-one bookmark manager";
      categories = [
        "Archiving"
        "Utility"
      ];
      startupWMClass = "Raindrop.io";
      mimeTypes = [ "x-scheme-handler/rnio" ];
    })
  ];

  passthru.updateScript = ./update.sh;

  meta = {
    description = "All-in-one bookmark manager";
    homepage = "https://raindrop.io";
    changelog = "https://github.com/raindropio/desktop/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ travisty- ];
    mainProgram = "raindrop";
    platforms = [ "x86_64-linux" ];
  };
}
