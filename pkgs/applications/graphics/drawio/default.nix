{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeDesktopItem
, copyDesktopItems
, prefetch-yarn-deps
, makeWrapper
, nodejs
, yarn
, electron
}:

stdenv.mkDerivation rec {
  pname = "drawio";
  version = "22.1.2";

  src = fetchFromGitHub {
    owner = "jgraph";
    repo = "drawio-desktop";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-4S4N7vfDwzlNutPfHozy/z0LOAr8q8EepXV4tsy+yAU=";
  };

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-QM7qazr8Iv4gjO7vF5Wj564D/yB+ZWmMGQDtTFytK00=";
  };

  nativeBuildInputs = [
    prefetch-yarn-deps
    makeWrapper
    nodejs
    yarn
  ] ++ lib.optionals (!stdenv.isDarwin) [
    copyDesktopItems
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"
    yarn config --offline set yarn-offline-mirror "$offlineCache"
    fixup-yarn-lock yarn.lock
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

  '' + lib.optionalString stdenv.isDarwin ''
    cp -R ${electron}/Applications/Electron.app Electron.app
    chmod -R u+w Electron.app
    export CSC_IDENTITY_AUTO_DISCOVERY=false
    sed -i "/afterSign/d" electron-builder-linux-mac.json
  '' + ''
    yarn --offline run electron-builder --dir \
      --config electron-builder-linux-mac.json \
      -c.electronDist=${if stdenv.isDarwin then "." else "${electron}/libexec/electron"} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv dist/mac*/draw.io.app $out/Applications

    # Symlinking `draw.io` doesn't work; seems to look for files in the wrong place.
    makeWrapper $out/Applications/draw.io.app/Contents/MacOS/draw.io $out/bin/drawio
  '' + lib.optionalString (!stdenv.isDarwin) ''
    mkdir -p "$out/share/lib/drawio"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/drawio"

    install -Dm644 build/icon.svg "$out/share/icons/hicolor/scalable/apps/drawio.svg"

    makeWrapper '${electron}/bin/electron' "$out/bin/drawio" \
      --add-flags "$out/share/lib/drawio/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --inherit-argv0
  '' + ''

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
      startupWMClass = "draw.io";
    })
  ];

  meta = with lib; {
    description = "A desktop application for creating diagrams";
    homepage = "https://about.draw.io/";
    license = licenses.asl20;
    changelog = "https://github.com/jgraph/drawio-desktop/releases/tag/v${version}";
    maintainers = with maintainers; [ qyliss darkonion0 ];
    platforms = platforms.darwin ++ platforms.linux;
  };
}
