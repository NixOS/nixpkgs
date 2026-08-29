{
  lib,
  stdenv,

  autoPatchelfHook,
  buildNpmPackage,
  copyDesktopItems,
  fetchFromGitHub,
  fetchNpmDeps,
  makeDesktopItem,
  rustPlatform,

  electron_42,
  ente-web,
  ffmpeg,
  imagemagick,
  makeWrapper,
  vips,
}:
let
  version = "1.7.27";

  src = fetchFromGitHub {
    owner = "ente";
    repo = "ente";
    fetchSubmodules = true;
    sparseCheckout = [
      "desktop"
      "web"
      "rust"
    ];

    tag = "photos-desktop-v${version}";
    hash = "sha256-H6ac1xcoQsxftREukIHpcYc8lFxnvmyxS9xNcr8H3/U=";
  };

  electron = electron_42;

  resourcesDir =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/ente.app/Contents/Resources"
    else
      "$out/share/ente-desktop/resources";

  webCargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "ente-desktop-web-cargo-deps";
    sourceRoot = "${src.name}/rust";
    hash = "sha256-RWemVZmH/NAQ+yDv2jwLhpHZpcp8BK3lZ4GjHMVLGLA=";
  };

  webNpmDeps = fetchNpmDeps {
    inherit src;
    name = "ente-desktop-web-npm-deps";
    sourceRoot = "${src.name}/web";
    hash = "sha256-iSqxANhb/DC/57Ltw4F9YKjTlJaAeZG3K4NrUN/+omA=";
  };

  webApp = ente-web.overrideAttrs {
    inherit version src;
    npmDeps = webNpmDeps;
    cargoDeps = webCargoDeps;

    _ENTE_IS_DESKTOP = "1";
  };
in
buildNpmPackage (finalAttrs: {
  pname = "ente-desktop";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/desktop";

  npmDepsHash = "sha256-qhimZHLD6mTUomZylLCyWWwPPi/m0VgjkMXGu2Wdkis=";

  nativeBuildInputs = [
    imagemagick
    makeWrapper
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

  preConfigure = ''
    cp -R ${webApp}/ out/

    cp -R ${electron.dist} ./electron_dist
    chmod -R u+w ./electron_dist
  '';

  npmBuildScript = "build-main";

  npmBuildFlags = [
    "--"
    "--dir"
    "--c.electronDist=./electron_dist"
    "--c.electronVersion=${electron.version}"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "--c.mac.identity=null"
    "--c.mac.notarize=false"
  ];

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
  # https://github.com/ente/ente/blob/main/desktop/electron-builder.yml
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
