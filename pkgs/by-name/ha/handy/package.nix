{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  cmake,
  bun,
  nodejs,
  cctools,
  cargo-tauri,
  jq,
  writableTmpDirAsHomeHook,
  makeBinaryWrapper,
  swift,
  apple-sdk_26,

  # Linux-only
  webkitgtk_6_0,
  gtk3,
  glib,
  libsoup_3,
  alsa-lib,
  libayatana-appindicator,
  libevdev,
  libxtst,
  gtk-layer-shell,
  vulkan-loader,
  vulkan-headers,
  shaderc,
  gst_all_1,
  glib-networking,
  libx11,
  pipewire,
  alsa-plugins,
  symlinkJoin,
  wrapGAppsHook4,

  # Cross-platform
  onnxruntime,
  openssl,
}:
let
  gstPlugins = lib.optionals stdenv.hostPlatform.isLinux (
    with gst_all_1;
    [
      gstreamer
      gst-plugins-base
      gst-plugins-good
      gst-plugins-bad
      gst-plugins-ugly
    ]
  );
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "handy";
  version = "0.8.3";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cjpais";
    repo = "Handy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sCCtp6UAxmCAcYeOM9+RW2czATh4Geqf1H8wXNMniYc=";
  };

  cargoRoot = "src-tauri";
  cargoHash = "sha256-mvOThNqfE24iMkVBM2zYexJkQxpMMgE4PPNXKy39hSg=";

  nativeInstallInputs = [ jq ];

  postPatch = ''
    patch_json() {
      local file=$1 filter=$2
      jq "$filter" "$file" > "$file.tmp" && mv "$file.tmp" "$file"
    }

    # De-structuring the Tauri build process
    # So we can:
    # - Handle the frontend building in a fixed way.
    # - Not worry about signing
    # - And avoid the auto-updater
    patch_json "src-tauri/tauri.conf.json" '
      del(.build.beforeBuildCommand) |
      .bundle.createUpdaterArtifacts = false |
      .bundle.macOS += { signingIdentity: null, hardenedRuntime: false }
    '

    # Avoid letting tauri try to install deps
    patch_json "package.json" 'del(.scripts.postinstall)'

    # Strip cbindgen build steps
    find "$cargoDepsCopy" -path "*/ferrous-opencc-*/build.rs" \
      -exec sed -i -e '/cbindgen::Builder::new/{:l;/write_to_file/!{N;bl};d}' {} +
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace "$cargoDepsCopy"/libappindicator-sys-*/src/lib.rs \
      --replace-fail 'libayatana-appindicator3.so.1' '${libayatana-appindicator}/lib/libayatana-appindicator3.so.1'
  '';

  nativeBuildInputs = [
    pkg-config
    cmake
    bun
    nodejs
    cargo-tauri.hook
    jq
    writableTmpDirAsHomeHook
    rustPlatform.bindgenHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
    shaderc
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    cctools
    swift
    apple-sdk_26
  ];

  buildInputs = [
    onnxruntime
    openssl
  ]
  ++ gstPlugins
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_6_0
    gtk3
    glib
    libsoup_3
    alsa-lib
    libayatana-appindicator
    libevdev
    libxtst
    gtk-layer-shell
    vulkan-loader
    vulkan-headers
    glib-networking
    libx11
  ];

  # Handy relies on onnx and gstreamer being available at runtime, picked up by wrapGapps.
  env = {
    ORT_LIB_LOCATION = "${lib.getLib onnxruntime}/lib";
    ORT_PREFER_DYNAMIC_LINK = "1";

    # Normally GST plugins will live in their own folder. This conjoins them into one as the application expects.
    GST_PLUGIN_SYSTEM_PATH_1_0 = lib.optionalString stdenv.hostPlatform.isLinux (
      lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstPlugins
    );
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    SWIFTC = "${swift}/bin/swiftc"; # Explicit so the Handy build system can avoid xcrun
  };

  preBuild = ''
    cp -R ${finalAttrs.passthru.frontendDeps}/node_modules .
    chmod -R u+w node_modules
    patchShebangs node_modules
    bun run build
  '';

  # If removed, the binary is produced, but not the app bundle for any platform.
  installPhase = ''
    runHook preInstall
    mkdir -p $out
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mv src-tauri/target/${stdenv.hostPlatform.rust.rustcTarget}/release/bundle/deb/*/data/usr/* $out/
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv src-tauri/target/${stdenv.hostPlatform.rust.rustcTarget}/release/bundle/macos/Handy.app \
      $out/Applications/
    ln -s "$out/Applications/Handy.app/Contents/MacOS/handy" "$out/bin/handy"
  ''
  + ''
    runHook postInstall
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --set WEBKIT_DISABLE_DMABUF_RENDERER 1
      --set ALSA_PLUGIN_DIR "${
        lib.makeSearchPathOutput "lib" "lib/alsa-lib" [
          pipewire
          alsa-plugins
        ]
      }"
    )
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool -add_rpath ${finalAttrs.finalPackage.env.ORT_LIB_LOCATION} \
      "$out/Applications/Handy.app/Contents/MacOS/handy"
  '';

  preCheck = ''
    cd ${finalAttrs.cargoRoot}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${finalAttrs.finalPackage.env.ORT_LIB_LOCATION}''${DYLD_LIBRARY_PATH:+:''${DYLD_LIBRARY_PATH}}"
  '';

  passthru = {
    # The hook and deps fetcher in https://github.com/NixOS/nixpkgs/pull/376299 should simplify this dramatically.
    frontendDeps = stdenv.mkDerivation {
      inherit (finalAttrs) version src;

      pname = "${finalAttrs.pname}-frontend-deps";

      nativeBuildInputs = [
        bun
        writableTmpDirAsHomeHook
      ];

      dontConfigure = true;

      buildPhase = ''
        runHook preBuild
        export BUN_INSTALL_CACHE_DIR=$(mktemp -d)
        bun install --linker=isolated --force --frozen-lockfile \
          --ignore-scripts --no-progress
        bun --bun "$PWD/.nix/scripts/normalize-install.ts"
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p $out
        cp -R node_modules $out/
        runHook postInstall
      '';

      dontFixup = true;

      outputHash =
        {
          "x86_64-linux" = "sha256-tJ6LK99dELOiR0BcsTRTt/vLyNamntujLxhBy5Xl/lc=";
          "aarch64-linux" = "sha256-S+dX6ZVgv9dexxIHoa5PxP7e0nxf/d7cKUGty5eEi8A=";
          "aarch64-darwin" = "sha256-DQbogNBQ9izK5GPmoOudqiB2lJvct1vZI2U5lp3WFy8=";
        }
        .${stdenv.hostPlatform.system};

      outputHashMode = "recursive";
    };
  };

  meta = {
    description = "Free, open source, offline speech-to-text application";
    longDescription = ''
      Handy is a cross-platform desktop application providing simple,
      privacy-focused speech transcription. Press a shortcut, speak, and
      have your words appear in any text field — entirely on your own
      computer, with no audio sent to the cloud.
    '';
    homepage = "https://handy.computer";
    changelog = "https://github.com/cjpais/Handy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = finalAttrs.pname;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = with lib.platforms; linux ++ darwin;
    badPlatforms = [ "x86_64-darwin" ]; # We weren't able to get hashes here
  };
})
