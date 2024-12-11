{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nix-update-script,
  electron,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  pkg-config,
  pixman,
  cairo,
  pango,
  npm-lockfile-fix,
  apple-sdk_11,
}:

buildNpmPackage rec {
  pname = "bruno";
  version = "1.34.2";

  src = fetchFromGitHub {
    owner = "usebruno";
    repo = "bruno";
    rev = "v${version}";
    hash = "sha256-ydb80+FP2IsobvCZiIKzbErAJNakVoSoYrhddmPmYkc=";

    postFetch = ''
      ${lib.getExe npm-lockfile-fix} $out/package-lock.json
    '';
  };

  npmDepsHash = "sha256-ODE8GLIgdUEOiniki8jzkHfU5TKHWoIIbjGJjNzMZCI=";
  npmFlags = [ "--legacy-peer-deps" ];

  nativeBuildInputs =
    [
      pkg-config
    ]
    ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
      makeWrapper
      copyDesktopItems
    ];

  buildInputs =
    [
      pixman
      cairo
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # fix for: https://github.com/NixOS/nixpkgs/issues/272156
      apple-sdk_11
    ];

  desktopItems = [
    (makeDesktopItem {
      name = "bruno";
      desktopName = "Bruno";
      exec = "bruno %U";
      icon = "bruno";
      comment = "Opensource API Client for Exploring and Testing APIs";
      categories = [ "Development" ];
      startupWMClass = "Bruno";
    })
  ];

  postPatch = ''
    substituteInPlace scripts/build-electron.sh \
      --replace-fail 'if [ "$1" == "snap" ]; then' 'exit 0; if [ "$1" == "snap" ]; then'
  '';

  postConfigure = ''
    # sh: line 1: /build/source/packages/bruno-common/node_modules/.bin/rollup: cannot execute: required file not found
    patchShebangs packages/*/node_modules
  '';

  ELECTRON_SKIP_BINARY_DOWNLOAD = 1;

  # remove giflib dependency
  npmRebuildFlags = [ "--ignore-scripts" ];
  preBuild = ''
    substituteInPlace node_modules/canvas/binding.gyp \
      --replace-fail "'with_gif%': '<!(node ./util/has_lib.js gif)'" "'with_gif%': 'false'"
    npm rebuild
  '';

  buildPhase = ''
    runHook preBuild

    npm run build --workspace=packages/bruno-common
    npm run build --workspace=packages/bruno-graphql-docs
    npm run build --workspace=packages/bruno-app
    npm run build --workspace=packages/bruno-query

    npm run sandbox:bundle-libraries --workspace=packages/bruno-js

    bash scripts/build-electron.sh

    pushd packages/bruno-electron

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          cp -r ${electron.dist}/Electron.app ./
          find ./Electron.app -name 'Info.plist' | xargs -d '\n' chmod +rw

          substituteInPlace electron-builder-config.js \
            --replace-fail "identity: 'Anoop MD (W7LPPWA48L)'" 'identity: null' \
            --replace-fail "afterSign: 'notarize.js'," ""

          npm exec electron-builder -- \
            --dir \
            --config electron-builder-config.js \
            -c.electronDist=./ \
            -c.electronVersion=${electron.version} \
            -c.npmRebuild=false
        ''
      else
        ''
          npm exec electron-builder -- \
            --dir \
            -c.electronDist=${electron.dist} \
            -c.electronVersion=${electron.version} \
            -c.npmRebuild=false
        ''
    }

    popd

    runHook postBuild
  '';

  npmPackFlags = [ "--ignore-scripts" ];

  installPhase = ''
    runHook preInstall


    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications

          cp -R packages/bruno-electron/out/**/Bruno.app $out/Applications/
        ''
      else
        ''
          mkdir -p $out/opt/bruno $out/bin

          cp -r packages/bruno-electron/dist/linux*-unpacked/{locales,resources{,.pak}} $out/opt/bruno

          makeWrapper ${lib.getExe electron} $out/bin/bruno \
            --add-flags $out/opt/bruno/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
            --set-default ELECTRON_IS_DEV 0 \
            --inherit-argv0

          for s in 16 32 48 64 128 256 512 1024; do
            size=${"$"}{s}x$s
            install -Dm644 $src/packages/bruno-electron/resources/icons/png/$size.png $out/share/icons/hicolor/$size/apps/bruno.png
          done
        ''
    }

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Open-source IDE For exploring and testing APIs";
    homepage = "https://www.usebruno.com";
    license = lib.licenses.mit;
    mainProgram = "bruno";
    maintainers = with lib.maintainers; [
      gepbird
      kashw2
      lucasew
      mattpolzin
      redyf
      water-sucks
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
