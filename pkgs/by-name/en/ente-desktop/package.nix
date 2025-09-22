{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchYarnDeps,
  nodejs,
  electron_37,
  yarnConfigHook,
  copyDesktopItems,
  vips,
  ffmpeg,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
  imagemagick,
}:
let
  electron = electron_37;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "ente-desktop";
  version = "1.7.14";

  src = fetchFromGitHub {
    owner = "ente-io";
    repo = "ente";
    fetchSubmodules = true;
    sparseCheckout = [
      "desktop"
      "web"
    ];
    tag = "photosd-v${finalAttrs.version}";
    hash = "sha256-UtKXg3SZxHo18VKuVP7W40SfZfa9ni+QJ7+GvGWptSA=";
  };

  sourceRoot = "${finalAttrs.src.name}/desktop";

  offlineCache = fetchYarnDeps {
    name = "ente-desktop-${finalAttrs.version}-offline-cache";
    inherit (finalAttrs) src sourceRoot;
    hash = "sha256-6o5TaqlgEQWZjde5cthiSVLVy5JiCHXApn7uXBWmTo0=";
  };
  webOfflineCache = fetchYarnDeps {
    name = "ente-desktop-${finalAttrs.version}-web-offline-cache";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/web";
    hash = "sha256-gwOeznAp4nGu4spilkFl8Dbmdye3Wg8VnBLroSdUjUo=";
  };

  nativeBuildInputs = [
    nodejs
    yarnConfigHook
    makeWrapper
    autoPatchelfHook # for onnxruntime
    copyDesktopItems
    imagemagick
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
      iedame
    ];
    platforms = lib.platforms.all;
  };
})
