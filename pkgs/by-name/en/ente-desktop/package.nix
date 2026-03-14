{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  electron_38,
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
  wasm-bindgen-cli_0_2_108,
  binaryen,
}:
let
  electron = electron_38;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-desktop";
  version = "1.7.21";

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
    hash = "sha256-nkI2wfjpQPWPmu+IKbNMQuqby2odRG3Dbyzd7cSxmYY=";
  };

  sourceRoot = "${finalAttrs.src.name}/desktop";
  cargoRoot = "../web/packages/wasm";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      cargoRoot
      ;
    hash = "sha256-ftb0h5MOHyQ2iec6iE7/WdHXgrviLCy8oIqFXv5OTq8=";
  };
  offlineCache = fetchYarnDeps {
    name = "ente-desktop-${finalAttrs.version}-offline-cache";
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-dnjTH68lNqSD/RIiaYdip0U8a2RXCNanqF05WnhzjEA=";
  };
  webOfflineCache = fetchYarnDeps {
    name = "ente-desktop-${finalAttrs.version}-web-offline-cache";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-NhpSwesQ9B5gEeBQVjEEAKO4A68wfmBoQ3ga/baieNE=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    makeWrapper
    autoPatchelfHook # for onnxruntime
    copyDesktopItems
    imagemagick

    wasm-pack
    rustPlatform.cargoSetupHook
    cargo
    rustc
    rustc.llvmPackages.lld
    wasm-bindgen-cli_0_2_108
    binaryen
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # for onnxruntime
  ];

  # Path to vips (otherwise it looks within the electron derivation)
  postPatch = ''
    substituteInPlace src/main/services/image.ts src/main.ts \
      --replace-fail "process.resourcesPath" "\"$out/share/ente-desktop/resources\""
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
    yarn run electron-builder --dir -c.electronDist=./electron_dist -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for size in 16 32 48 64 72 96 128 192 256 512 1024; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      convert -resize "$size"x"$size" build/icon.png $out/share/icons/hicolor/"$size"x"$size"/apps/ente-desktop.png
    done

    mkdir -p $out/share/ente-desktop
    cp -r dist/*/resources $out/share/ente-desktop
    ln -s ${vips}/bin/vips $out/share/ente-desktop/resources/vips
    ln -s ${ffmpeg}/bin/ffmpeg $out/share/ente-desktop/resources/app.asar.unpacked/node_modules/ffmpeg-static/ffmpeg

    # executable wrapper
    makeWrapper '${electron}/bin/electron' "$out/bin/ente-desktop" \
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --set ELECTRON_IS_DEV 0 \
      --add-flags "$out/share/ente-desktop/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    runHook postInstall
  '';

  # The desktop item properties should be kept in sync with data from upstream:
  # https://github.com/ente-io/ente/blob/main/desktop/electron-builder.yml
  desktopItems = [
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
    ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
