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
  version = "29.7.9";

  src = fetchFromGitHub {
    owner = "jgraph";
    repo = "drawio-desktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-D3jrVGP0RHKssSjvA8pg1qXfTjYq+linbXCbZz2kTNw=";
  };

  # `@electron/fuses` tries to run `codesign` and fails. Disable and use autoSignDarwinBinariesHook instead
  postPatch = ''
    substituteInPlace ./build/fuses.cjs \
      --replace-fail "resetAdHocDarwinSignature:" "// resetAdHocDarwinSignature:"
  '';

  offlineCache = fetchNpmDeps {
    src = finalAttrs.src;
    hash = "sha256-luOQn7S5hXdUa3VrJyQRt0IFLnzfrnTNHIIZSqHQhaI=";
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

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp -R ${electron.dist}/Electron.app Electron.app
    chmod -R u+w Electron.app
    export CSC_IDENTITY_AUTO_DISCOVERY=false
    sed -i "/afterSign/d" electron-builder-linux-mac.json
  ''
  + ''
    npm exec electron-builder -- \
      --dir \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "--config electron-builder-linux-mac.json --config.mac.identity=null"} \
      -c.electronDist=${if stdenv.hostPlatform.isDarwin then "." else electron.dist} \
      -c.electronVersion=${electron.version}

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
    license = with lib.licenses; [
      # The LICENSE file of https://github.com/jgraph/drawio claims Apache License Version 2.0 again since https://github.com/jgraph/drawio/commit/5b2e73471e4fea83d681f0cec5d1aaf7c3884996
      asl20
      # But the README says:
      # The minified code authored by us in this repo is licensed under an Apache v2 license, but the sources to build those files are not in this repo. This is not an open source project.
      unfreeRedistributable
    ];
    changelog = "https://github.com/jgraph/drawio-desktop/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ darkonion0 ];
    platforms = lib.platforms.darwin ++ lib.platforms.linux;
    mainProgram = "drawio";
  };
})
