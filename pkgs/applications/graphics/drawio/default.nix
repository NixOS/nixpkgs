{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeDesktopItem
, copyDesktopItems
, desktopToDarwinBundle
, fixup_yarn_lock
, makeWrapper
, nodejs
, yarn
, electron
}:

stdenv.mkDerivation rec {
  pname = "drawio";
  version = "21.6.8";

  src = fetchFromGitHub {
    owner = "jgraph";
    repo = "drawio-desktop";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-k16npV8N4zPIXjc8ZJcQHgv76h2VhbqtT2ZCzDqkF8U";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-rJvwXhtO/HsfpbDyOh+jFc6E9wQ+sZMT8vnhJpGlkF8";
  };

  nativeBuildInputs = [
    copyDesktopItems
    fixup_yarn_lock
    makeWrapper
    nodejs
    yarn
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup_yarn_lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    yarn --offline run electron-builder --dir \
      --config electron-builder-linux-mac.json \
      -c.electronDist=${electron}/lib/electron \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/lib/drawio"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/drawio"

    install -Dm644 build/icon.svg "$out/share/icons/hicolor/scalable/apps/drawio.svg"

    makeWrapper '${electron}/bin/electron' "$out/bin/drawio" \
      --add-flags "$out/share/lib/drawio/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "drawio";
      exec = "drawio %U";
      icon = "drawio";
      desktopName = "drawio";
      comment = "draw.io desktop";
      mimeTypes = [ "application/vnd.jgraph.mxfile" "application/vnd.visio" ];
      categories = [ "Graphics" ];
      startupWMClass = "drawio";
    })
  ];

  meta = with lib; {
    description = "A desktop application for creating diagrams";
    homepage = "https://about.draw.io/";
    license = licenses.asl20;
    changelog = "https://github.com/jgraph/drawio-desktop/releases/tag/v${version}";
    maintainers = with maintainers; [ qyliss darkonion0 ];
    platforms = platforms.darwin ++ platforms.linux;
    broken = stdenv.isDarwin;
  };
}
