{
  meta,
  nodejs,
  npmDeps,
  src,
  version,

  autoPatchelfHook,
  buildNpmPackage,
  copyDesktopItems,
  electron_44,
  lib,
  libuv,
  makeDesktopItem,
  makeWrapper,
  python3,
  stdenv,
}:

let
  electron = electron_44;
in
buildNpmPackage {
  pname = "paseo-desktop";
  inherit
    version
    src
    nodejs
    npmDeps
    ;

  __structuredAttrs = true;
  strictDeps = true;

  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    makeWrapper
    python3
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libuv
    stdenv.cc.cc.lib
  ];

  env = {
    CI = "1";
    EXPO_NO_TELEMETRY = "1";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  postPatch = ''
    substituteInPlace packages/desktop/src/features/auto-updater.ts \
      --replace-fail 'isPackaged: () => app.isPackaged,' 'isPackaged: () => false,'
  '';

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild

    npm_config_build_from_source=true npm_config_nodedir=${nodejs} \
      npm rebuild node-pty --workspace @getpaseo/server

    npm run build:server
    npm run build --workspace @getpaseo/expo-two-way-audio
    (
      cd packages/app
      PASEO_WEB_PLATFORM=electron npm exec -- expo export --platform web
    )
    npm run build:main --workspace @getpaseo/desktop
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    cp --recursive ${electron.dist} electron-dist
    chmod --recursive u+w electron-dist
    electron_dist="$PWD/electron-dist"

    (
      cd packages/desktop
      CSC_IDENTITY_AUTO_DISCOVERY=false npm exec -- electron-builder \
        --config electron-builder.yml \
        --dir \
        --mac \
        --publish never \
        --config.electronDist="$electron_dist" \
        --config.electronVersion=${electron.version} \
        --config.buildVersion=${version} \
        --config.mac.identity=null \
        --config.mac.hardenedRuntime=false \
        --config.mac.notarize=false
    )
  ''
  + ''
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir --parents $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir --parents $out/share/paseo-desktop
    PASEO_TRACE_DESKTOP=1 node scripts/trace-daemon.mjs > desktop-files.txt

    while IFS= read -r path; do
      mkdir --parents "$out/share/paseo-desktop/$(dirname "$path")"
      cp --archive "$path" "$out/share/paseo-desktop/$path"
    done < desktop-files.txt

    patchShebangs --build $out/share/paseo-desktop
    cp package.json $out/share/paseo-desktop/
    mkdir --parents $out/share/paseo-desktop/packages/app
    cp --archive packages/app/dist $out/share/paseo-desktop/packages/app/

    mkdir --parents $out/share/icons/hicolor/512x512/apps
    install --mode=644 packages/desktop/assets/icon.png \
      $out/share/icons/hicolor/512x512/apps/paseo-desktop.png

    mkdir --parents $out/share/paseo-desktop/electron-app
    printf '%s\n' '{ "name": "paseo-desktop", "version": "${version}", "main": "index.js" }' \
      > $out/share/paseo-desktop/electron-app/package.json
    printf '%s\n' 'require("../packages/desktop/dist/main.js");' \
      > $out/share/paseo-desktop/electron-app/index.js

    makeWrapper ${lib.getExe electron} $out/bin/paseo-desktop \
      --add-flags "$out/share/paseo-desktop/electron-app" \
      --add-flags "--class=paseo-desktop" \
      --set EXPO_DEV_URL "paseo://app/" \
      --set CHROME_DESKTOP "paseo-desktop.desktop"
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir --parents $out/Applications
    cp --recursive packages/desktop/release/mac*/Paseo.app $out/Applications/
    makeWrapper $out/Applications/Paseo.app/Contents/MacOS/Paseo $out/bin/paseo-desktop
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "paseo-desktop";
      desktopName = "Paseo";
      genericName = "AI Coding Agents";
      comment = meta.description;
      exec = "paseo-desktop %u";
      icon = "paseo-desktop";
      categories = [ "Development" ];
      mimeTypes = [ "x-scheme-handler/paseo" ];
      startupWMClass = "Paseo";
    })
  ];

  meta = meta // {
    description = "Desktop app for orchestrating multiple coding agents";
    mainProgram = "paseo-desktop";
  };
}
