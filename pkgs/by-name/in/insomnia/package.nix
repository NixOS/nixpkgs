{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  makeWrapper,
  python3,
  pkg-config,
  curl,
  electron_41,
  copyDesktopItems,
  makeDesktopItem,
}:

let
  electron = electron_41;
in
buildNpmPackage rec {
  pname = "insomnia";
  version = "13.0.0";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "insomnia";
    rev = "core@${version}";
    hash = "sha256-+eWLO8f9dqsssoqu1EGg2kNVckXVcRuWyfp8h6FYVbU=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  npmDepsHash = "sha256-zc3JLmriut7YTLDuORRCMJG+djs6WEnBRwF2Io5rnLI=";

  postPatch = ''
    ${python3}/bin/python3 ${./patch-package.py}

    echo "DEBUG: package-lock.json status after patching:"
    ls -lh package-lock.json
    head -n 10 package-lock.json
  '';

  nativeBuildInputs = [
    makeWrapper
    python3
    pkg-config
    curl.dev
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    copyDesktopItems
  ];

  buildInputs = [
    curl
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
    NODE_OPTIONS = "--max-old-space-size=8192";
  };

  makeCacheWritable = true;

  npmBuildScript = "app-build";

  preBuild = ''
    echo "DEBUG: checking grpc-reflection-js in node_modules:"
    ls -la node_modules/grpc-reflection-js || echo "grpc-reflection-js is MISSING!"
  '';

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    patch -p1 -d node_modules/nan < ${./nan-v8-13.patch}

    echo "DEBUG: forcing clean rebuild of node-libcurl against Electron ABI"
    rm -rf node_modules/@getinsomnia/node-libcurl/lib/binding
    HOME=$TMPDIR node_modules/.bin/node-pre-gyp rebuild \
      --directory node_modules/@getinsomnia/node-libcurl \
      --runtime=electron \
      --target=${electron.version} \
      --nodedir=${electron.headers} \
      --build-from-source \
      --verbose

    pushd packages/insomnia
    npm exec electron-builder -- \
      --dir \
      --config electron-builder.config.js \
      -c.electronDist=../../electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null
    popd
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r packages/insomnia/dist/mac*/Insomnia.app $out/Applications
    makeWrapper $out/Applications/Insomnia.app/Contents/MacOS/Insomnia $out/bin/insomnia
  ''
  + lib.optionalString (!stdenv.hostPlatform.isDarwin) ''
    mkdir -p $out/share/insomnia
    cp -r packages/insomnia/dist/linux*-unpacked/{locales,resources{,.pak}} $out/share/insomnia

    # XDG Desktop Item and Icon
    if [ -d packages/insomnia/build/icons ]; then
      for icon in packages/insomnia/build/icons/*.png; do
        size=$(basename "$icon" .png)
        mkdir -p "$out/share/icons/hicolor/$size/apps"
        cp "$icon" "$out/share/icons/hicolor/$size/apps/insomnia.png"
      done
    elif [ -f packages/insomnia/build/icon.png ]; then
      mkdir -p "$out/share/icons/hicolor/512x512/apps"
      cp packages/insomnia/build/icon.png "$out/share/icons/hicolor/512x512/apps/insomnia.png"
    fi

    makeWrapper ${lib.getExe electron} $out/bin/insomnia \
      --add-flags $out/share/insomnia/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "insomnia";
      exec = "insomnia %U";
      icon = "insomnia";
      desktopName = "Insomnia";
      comment = meta.description;
      categories = [ "Development" ];
    })
  ];

  meta = {
    homepage = "https://insomnia.rest";
    description = "Open-source, cross-platform API client for GraphQL, REST, WebSockets, SSE and gRPC, with Cloud, Local and Git storage";
    mainProgram = "insomnia";
    changelog = "https://github.com/Kong/insomnia/releases/tag/core@${version}";
    license = lib.licenses.asl20;
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
    maintainers = with lib.maintainers; [
      markus1189
      kashw2
      DataHearth
    ];
  };
}
