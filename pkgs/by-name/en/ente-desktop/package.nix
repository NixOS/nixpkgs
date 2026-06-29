{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  electron_41,
  yarnConfigHook,
  copyDesktopItems,
  vips,
  ffmpeg,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
  imagemagick,
  wasm-pack,
  rustPlatform,
  cargo,
  rustc,
  wasm-bindgen-cli_0_2_121,
  binaryen,
}:
let
  electron = electron_41;

  resourcesDir =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/ente.app/Contents/Resources"
    else
      "$out/share/ente-desktop/resources";
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-desktop";
  version = "1.7.24";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    fetchSubmodules = true;
    sparseCheckout = [
      "desktop"
      "web"
      "rust"
    ];
    tag = "photosd-v${finalAttrs.version}";
    hash = "sha256-/dO9qLJKbqR5h/GEJW9rLO1jNTa5GkqnJ9ORPSf5R8o=";
  };

  sourceRoot = "${finalAttrs.src.name}/desktop";
  cargoRoot = "../rust";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-F+g/6mcMnplOkTlR/vedS3MhimFAbXFZi6CTJ/cqoU0=";
  };
  offlineCache = fetchYarnDeps {
    name = "ente-desktop-${finalAttrs.version}-offline-cache";
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-ne3gyI6psDpYzCPpepIIWao0yBiiv9qXQ+Iri3ELK/U=";
  };
  webOfflineCache = fetchYarnDeps {
    name = "ente-desktop-${finalAttrs.version}-web-offline-cache";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-MqsmOHVyPz+YiwNmrs447wrQ/Nk+t5TrLMsbDITM8p0=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    makeWrapper
    imagemagick

    wasm-pack
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustc.llvmPackages.lld
    wasm-bindgen-cli_0_2_121
    binaryen
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook # for onnxruntime
    copyDesktopItems
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # for onnxruntime
  ];

  # Path to vips (otherwise it looks within the electron derivation)
  postPatch = ''
    substituteInPlace src/main/services/image.ts src/main.ts \
      --replace-fail "process.resourcesPath" "\"${resourcesDir}\""
  '';

  postConfigure = ''
    chmod u+w -R ..

    pushd ../web
    offlineCache=$webOfflineCache yarnConfigHook
    rm -rf node_modules/wasm-pack node_modules/.bin/wasm-pack
    popd

    cp -r ${electron.dist} ./electron_dist
    chmod u+w -R ./electron_dist
  '';

  buildPhase = ''
    runHook preBuild

    pushd ../web
    _ENTE_IS_DESKTOP=1 yarn build
    popd
    cp -r ../web/apps/photos/out out

    yarn run tsc
    yarn run electron-builder -- \
      --dir \
      --c.electronDist=./electron_dist \
      --c.electronVersion=${electron.version} \
      ${lib.optionalString stdenv.hostPlatform.isDarwin ''
        --c.mac.identity=null \
        --c.mac.notarize=false \
      ''}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/Applications
      cp -r dist/*/ente.app $out/Applications

      mkdir -p $out/bin
      ln -s $out/Applications/ente.app/Contents/MacOS/ente $out/bin/ente-desktop
    ''}

    ${lib.optionalString stdenv.hostPlatform.isLinux ''
      for size in 16 32 48 64 72 96 128 192 256 512 1024; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        convert -resize "$size"x"$size" build/icon.png $out/share/icons/hicolor/"$size"x"$size"/apps/ente-desktop.png
      done

      mkdir -p $out/share/ente-desktop
      cp -r dist/*/resources $out/share/ente-desktop

      # executable wrapper
      makeWrapper '${electron}/bin/electron' "$out/bin/ente-desktop" \
        --set ELECTRON_FORCE_IS_PACKAGED 1 \
        --set ELECTRON_IS_DEV 0 \
        --add-flags "${resourcesDir}/app.asar" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
    ''}

    ln -s ${vips}/bin/vips ${resourcesDir}/vips
    ln -s ${ffmpeg}/bin/ffmpeg ${resourcesDir}/app.asar.unpacked/node_modules/ffmpeg-static/ffmpeg

    runHook postInstall
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/ente-io/ente/blob/main/desktop/electron-builder.yml
  desktopItems = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (makeDesktopItem {
      name = "ente-desktop";
      desktopName = "Ente";
      exec = "ente-desktop %U";
      terminal = false;
      type = "Application";
      icon = "ente-desktop";
      mimeTypes = [
        "x-scheme-handler/ente"
      ];
      categories = [
        "Photography"
      ];
    })
  ];

  meta = {
    description = "Desktop (Electron) client for Ente Photos";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente-io/photos-desktop/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      yuka
      Br1ght0ne
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
