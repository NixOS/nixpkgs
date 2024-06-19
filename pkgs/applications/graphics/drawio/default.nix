{ lib
, stdenv
, fetchFromGitHub
, fetchYarnDeps
, makeDesktopItem
, copyDesktopItems
, fixup-yarn-lock
, makeWrapper
, autoSignDarwinBinariesHook
, nodejs
, yarn
, electron
}:

stdenv.mkDerivation rec {
  pname = "drawio";
  version = "24.4.8";

  src = fetchFromGitHub {
    owner = "jgraph";
    repo = "drawio-desktop";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-dtkRi7oisdgMAbaltPcz5umxcd6/F1WOjKQpJUAFFY0=";
  };

  # `@electron/fuses` tries to run `codesign` and fails. Disable and use autoSignDarwinBinariesHook instead
  postPatch = ''
    sed -i -e 's/resetAdHocDarwinSignature:.*/resetAdHocDarwinSignature: false,/' build/fuses.cjs
  '';

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-JbDIaO5jgPAoSD3hkMaKp3vLU5Avt+G5h427bvWJ08k=";
  };

  nativeBuildInputs = [
    fixup-yarn-lock
    makeWrapper
    nodejs
    yarn
  ] ++ lib.optionals (!stdenv.isDarwin) [
    copyDesktopItems
  ] ++ lib.optionals stdenv.isDarwin [
    autoSignDarwinBinariesHook
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
      ${if stdenv.isDarwin then "--config electron-builder-linux-mac.json" else ""} \
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
    description = "Desktop application for creating diagrams";
    homepage = "https://about.draw.io/";
    license = licenses.asl20;
    changelog = "https://github.com/jgraph/drawio-desktop/releases/tag/v${version}";
    maintainers = with maintainers; [ qyliss darkonion0 ];
    platforms = platforms.darwin ++ platforms.linux;
    mainProgram = "drawio";
  };
}
