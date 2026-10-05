{
  lib,
  stdenv,

  autoPatchelfHook,
  buildNpmPackage,
  cargo,
  cmake,
  copyDesktopItems,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  makeDesktopItem,
  pkg-config,
  rustPlatform,
  rustc,

  electron_42,
  ente-web,
  ffmpeg,
  imagemagick,
  makeWrapper,
  vips,
  vulkan-loader,

  wasm-bindgen-cli_0_2_125,

  nix-update-script,
}:
let
  version = "1.7.29";

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
    hash = "sha256-/9qsChxnRQ0KGEuLL6hxDcyYkhLs9sKG+fbE6ZMSp4I=";
  };

  electron = electron_42;

  inherit (stdenv.hostPlatform.node) arch;

  # The N-API addon requires ONNX Runtime API 28, newer than nixpkgs provides.
  # Upstream's build enables WebGPU on Linux and CoreML on macOS.
  # Match the version, archive names and hashes in desktop/scripts/ort.js.
  onnxruntimeVersion = "1.28.1-r1";
  onnxruntimePlatform = if stdenv.hostPlatform.isDarwin then "coreml-macos" else "webgpu-linux";
  onnxruntimeArchiveName = "onnxruntime-${onnxruntimePlatform}-${arch}-${onnxruntimeVersion}.tar.gz";
  onnxruntime = fetchurl {
    url = "https://github.com/ente/ort-packaging/releases/download/ort-${onnxruntimeVersion}/${onnxruntimeArchiveName}";
    hash =
      {
        x86_64-linux = "sha256-lOVTNiFOiR6fZIkB8MgV8RPRU0zsroLs75w4KM1z1PQ=";
        aarch64-linux = "sha256-Lrcc7VDha04tSrILkkJ21Q0SNBeWKn2HSgzbfwFxxj0=";
        aarch64-darwin = "sha256-EokKhx0OZY3QZL4Yf6Y9J8a2kuaflNR1BTL9j00XnB4=";
      }
      .${stdenv.hostPlatform.system};
  };

  resourcesDir =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/ente.app/Contents/Resources"
    else
      "$out/share/ente-desktop/resources";

  webCargoDeps = rustPlatform.fetchCargoVendor {
    inherit src;
    name = "ente-desktop-web-cargo-deps";
    sourceRoot = "${src.name}/rust";
    hash = "sha256-+QXvWN4RiWkcQ8tNTqwrVle+KmJ7Pol470EprqoV1Pg=";
  };

  webNpmDeps = fetchNpmDeps {
    inherit src;
    name = "ente-desktop-web-npm-deps";
    sourceRoot = "${src.name}/web";
    hash = "sha256-VaWrXfJ3yCxyl+JSKhPnVnuLvIrstdIbllnLZ94K650=";
  };

  webApp =
    (ente-web.override {
      # This produces an eval error when we're out of sync with ente-web
      wasm-bindgen-cli_0_2_125 = wasm-bindgen-cli_0_2_125;
      extraBuildEnv = {
        _ENTE_IS_DESKTOP = "1";
      };
    }).overrideAttrs
      {
        inherit version src;
        npmDeps = webNpmDeps;
        cargoDeps = webCargoDeps;
      };
in
buildNpmPackage (finalAttrs: {
  pname = "ente-desktop";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/desktop";

  npmDepsHash = "sha256-9ROnHGq/2q7fLo2eVghgCDqEcethtQYyC6Cffp4R0aE=";

  cargoDeps = webCargoDeps;
  cargoRoot = "../rust";
  dontUseCmakeConfigure = true;

  nativeBuildInputs = [
    cargo
    cmake
    imagemagick
    makeWrapper
    pkg-config
    rustc
    rustPlatform.bindgenHook
    rustPlatform.cargoSetupHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook # for onnxruntime
    copyDesktopItems
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # for onnxruntime
  ];

  # ONNX Runtime loads execution providers from its own directory.
  # The WebGPU provider loads the Vulkan loader at runtime.
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    "$ORIGIN"
    "${lib.getLib vulkan-loader}/lib"
  ];

  # The Linux wrapper runs nixpkgs' Electron. Override its process.resourcesPath
  # so it finds this package's bundled resources.
  postPatch = ''
    chmod -R u+w ../rust

    substituteInPlace src/main/services/image.ts src/main/services/ml-native.ts src/main.ts \
      --replace-fail "process.resourcesPath" "\"${resourcesDir}\""

    # Use the Nix toolchain instead of napi-cli's downloaded cross compiler.
    substituteInPlace scripts/napi.js \
      --replace-fail '["--use-napi-cross"]' '[]'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Build only for the host architecture instead of both macOS architectures.
    substituteInPlace scripts/napi.js scripts/ort.js \
      --replace-fail 'platform == "darwin" ? ["arm64", "x64"] : [arch]' '[arch]'
  '';

  preConfigure = ''
    cp -R ${webApp}/ out/

    cp -R ${electron.dist} ./electron_dist
    chmod -R u+w ./electron_dist

    mkdir -p node_modules/.cache/ente-onnxruntime/${arch}
    tar -xzf ${onnxruntime} -C node_modules/.cache/ente-onnxruntime/${arch}
    # scripts/ort.js compares this stamp verbatim before staging the runtime.
    # It must contain the archive name without a trailing newline.
    printf '%s' '${onnxruntimeArchiveName}' > node_modules/.cache/ente-onnxruntime/${arch}/.ente-ort-stamp
  '';

  npmBuildScript = "build-main";

  npmBuildFlags = [
    "--"
    "--dir"
    "--${arch}"
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

  passthru = {
    inherit webApp;
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "photos-desktop-v(.*)"
        "--subpackage"
        "webApp"
      ];
    };
  };

  meta = {
    description = "Desktop (Electron) client for Ente Photos";
    homepage = "https://ente.io/";
    changelog = "https://github.com/ente/photos-desktop/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # Upstream's ONNX Runtime distribution.
    ];
    mainProgram = "ente-desktop";
    maintainers = with lib.maintainers; [
      pinpox
      yuka
      Br1ght0ne
      wrench-exile-legacy
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
