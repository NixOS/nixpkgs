{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  makeDesktopItem,
  copyDesktopItems,
  npm-lockfile-fix,
  makeWrapper,
  darwin,
  nodejs,
  electron,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drawio";
  version = "30.2.6";

  src = fetchFromGitHub {
    owner = "jgraph";
    repo = "drawio-desktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-hn+Lrsn+aNZqVFcyLinuJjUiQgai0o4F5d5cT9CvtLA=";
  };

  # `@electron/fuses` tries to run `codesign` and fails. Disable and use autoSignDarwinBinariesHook instead
  postPatch = ''
    substituteInPlace ./build/fuses.mjs \
      --replace-fail "resetAdHocDarwinSignature:" "// resetAdHocDarwinSignature:"
  '';

  offlineCache = fetchNpmDeps {
    src = finalAttrs.src;
    hash = "sha256-PnYUy0Arxo5uTYyYfUEkbd4u7oIOHkEc0/ufp0umBhE=";
  };

  nativeBuildInputs = [
    npm-lockfile-fix
    makeWrapper
    nodejs
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = true;

  configurePhase = ''
    runHook preConfigure

    export HOME="$TMPDIR"
    npm config set cache "$offlineCache"
    npm-lockfile-fix package-lock.json
    npm ci --offline --ignore-scripts --no-audit --no-fund
    patchShebangs node_modules/

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    electron_dist="$(mktemp -d)"
    cp -r ${electron.dist}/. "$electron_dist"
    chmod -R u+w "$electron_dist"

    sed -i "/afterSign/d" electron-builder-linux-mac.json

    npm exec electron-builder -- \
      --dir \
      --config electron-builder-linux-mac.json \
      -c.electronDist="$electron_dist" \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    mv dist/mac*/draw.io.app $out/Applications

    # Symlinking `draw.io` doesn't work; seems to look for files in the wrong place.
    makeWrapper $out/Applications/draw.io.app/Contents/MacOS/draw.io $out/bin/drawio
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p "$out/share/lib/drawio"
    cp -r dist/*-unpacked/{locales,resources{,.pak}} "$out/share/lib/drawio"

    install -Dm644 build/icon.svg "$out/share/icons/hicolor/scalable/apps/drawio.svg"

    makeWrapper '${electron}/bin/electron' "$out/bin/drawio" \
      --add-flags "$out/share/lib/drawio/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
  ''
  + ''

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "drawio";
      exec = "drawio %U";
      icon = "drawio";
      desktopName = "drawio";
      comment = "draw.io desktop";
      mimeTypes = [
        "application/vnd.jgraph.mxfile"
        "application/vnd.visio"
      ];
      categories = [ "Graphics" ];
      startupWMClass = "draw.io";
    })
  ];

  meta = {
    description = "Desktop version of draw.io for creating diagrams";
    homepage = "https://about.draw.io/";
    license = lib.licenses.asl20;
    changelog = "https://github.com/jgraph/drawio-desktop/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ darkonion0 ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    mainProgram = "drawio";
  };
})
