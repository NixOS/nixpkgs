{
  lib,
  stdenv,

  autoPatchelfHook,
  buildNpmPackage,
  copyDesktopItems,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchurl,
  makeDesktopItem,
  rustPlatform,

  cargo,
  electron_42,
  ente-web,
  ffmpeg,
  imagemagick,
  makeWrapper,
  rustc,
  vips,
  vulkan-loader,

  wasm-bindgen-cli_0_2_125,
  wasm-pack,

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

  # ente-photos-napi needs ONNX Runtime API 28, so use the build pinned in
  # desktop/scripts/ort.js (nixpkgs' onnxruntime is older).
  ortVersion = "1.28.1-r1";
  ortPlatforms = {
    x86_64-linux = {
      arch = "x64";
      asset = "onnxruntime-webgpu-linux-x64-${ortVersion}.tar.gz";
      hash = "sha256-lOVTNiFOiR6fZIkB8MgV8RPRU0zsroLs75w4KM1z1PQ=";
    };
    aarch64-linux = {
      arch = "arm64";
      asset = "onnxruntime-webgpu-linux-arm64-${ortVersion}.tar.gz";
      hash = "sha256-Lrcc7VDha04tSrILkkJ21Q0SNBeWKn2HSgzbfwFxxj0=";
    };
    x86_64-darwin = {
      arch = "x64";
      asset = "onnxruntime-coreml-macos-x64-${ortVersion}.tar.gz";
      hash = "sha256-jJbahWg0O1q0luk9ESpdYSbAHl3MTmcZIZqmeK1qviU=";
    };
    aarch64-darwin = {
      arch = "arm64";
      asset = "onnxruntime-coreml-macos-arm64-${ortVersion}.tar.gz";
      hash = "sha256-EokKhx0OZY3QZL4Yf6Y9J8a2kuaflNR1BTL9j00XnB4=";
    };
  };
  ortPlatform =
    ortPlatforms.${stdenv.hostPlatform.system}
      or (throw "ente-desktop: unsupported system ${stdenv.hostPlatform.system}");
  onnxruntime = fetchurl {
    url = "https://github.com/ente/ort-packaging/releases/download/ort-${ortVersion}/${ortPlatform.asset}";
    inherit (ortPlatform) hash;
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

        # The wasm package has been split into one workspace per app, which
        # ente-web does not handle yet.
        postPatch = ''
          chmod -R u+w ../rust

          substituteInPlace packages/wasm/*/package.json \
            --replace-fail "wasm-pack " ${lib.escapeShellArg "${wasm-pack}/bin/wasm-pack "}

          # The cast bindings disable reference-types and rebuild std with nightly
          # `-Z build-std` to support Chromecast browsers. Within the desktop app
          # they only run in Electron, so build them with the stable toolchain.
          substituteInPlace packages/wasm/cast/package.json \
            --replace-fail " -- -Z build-std=panic_abort,std" ""
          rm ../rust/bindings/wasm/cast/.cargo/config.toml
        '';
      };
in
buildNpmPackage (finalAttrs: {
  pname = "ente-desktop";
  inherit version src;

  sourceRoot = "${finalAttrs.src.name}/desktop";

  npmDepsHash = "sha256-9ROnHGq/2q7fLo2eVghgCDqEcethtQYyC6Cffp4R0aE=";

  cargoDeps = webCargoDeps;
  cargoRoot = "../rust";

  nativeBuildInputs = [
    cargo
    imagemagick
    makeWrapper
    rustPlatform.cargoSetupHook
    rustc
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    autoPatchelfHook # for onnxruntime
    copyDesktopItems
  ];

  buildInputs = [
    (lib.getLib stdenv.cc.cc) # for onnxruntime
  ];

  # onnxruntime loads its execution providers from its own directory, and the
  # WebGPU execution provider loads Vulkan at runtime
  appendRunpaths = lib.optionals stdenv.hostPlatform.isLinux [
    "$ORIGIN"
    "${lib.getLib vulkan-loader}/lib"
  ];

  # Path to vips, the N-API addon and onnxruntime (otherwise it looks within
  # the electron derivation)
  postPatch = ''
    substituteInPlace src/main/services/image.ts src/main/services/ml-native.ts src/main.ts \
      --replace-fail "process.resourcesPath" "\"${resourcesDir}\""

    # The Rust workspace lives outside the `desktop` sourceRoot
    chmod -R u+w ../rust

    # The N-API addon and onnxruntime are built and staged in preBuild instead,
    # as upstream's scripts use rustup, napi-cross and download onnxruntime.
    substituteInPlace package.json \
      --replace-fail '"npm run codegen:napi && tsc && electron-builder"' '"tsc && electron-builder"'
    substituteInPlace scripts/beforeBuild.js \
      --replace-fail "await stageONNXRuntime(platform.nodeName, arch, appDir);" "" \
      --replace-fail "await stageNapiAddons(appDir, platform.nodeName, arch);" ""
  '';

  preConfigure = ''
    cp -R ${webApp}/ out/

    cp -R ${electron.dist} ./electron_dist
    chmod -R u+w ./electron_dist
  '';

  preBuild = ''
    npm exec -- napi build \
      --manifest-path ../rust/bindings/napi/photos/Cargo.toml \
      --target-dir ../rust/target \
      --release --strip --platform --no-js \
      --dts index.d.ts \
      --output-dir rust-bindings

    mkdir -p build/napi
    cp rust-bindings/*.node build/napi/

    mkdir -p build/onnxruntime/${ortPlatform.arch}
    tar -xf ${onnxruntime} -C build/onnxruntime/${ortPlatform.arch}
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
    changelog = "https://github.com/ente-io/photos-desktop/releases";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      pinpox
      yuka
      Br1ght0ne
      wrench-exile-legacy
    ];
    platforms = lib.attrNames ortPlatforms;
  };
})
