{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchNpmDeps,
  rustPlatform,
  makeWrapper,
  pkg-config,
  wrapGAppsHook4,
  openssl,
  onnxruntime,
  webkitgtk_4_1,
  gtk3,
  glib,
  gdk-pixbuf,
  libappindicator,
  cairo,
  pango,
  libxrender,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxcursor,
  libx11,
  libxcb,
  libxkbcommon,
  vulkan-loader,
  libjpeg,
  libpng,
  zlib,
  libGL,
  dbus,
  gvfs,
  libheif,
  glib-networking,
  nodejs_24,
  npmHooks,
  cargo-tauri,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rapidraw";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "CyberTimon";
    repo = "RapidRAW";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NYns/hpa8E4oko3qxyrJaTpgH5b+dwr0dTFw+K3IBDo=";
  };

  cargoHash = "sha256-wuTbUPkPJTg6WZYrffrfPm+Asr0PuL5UAsZL+qWM4Oo=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-CBCj1R6ClnRh5Y4liKNiewRPb2lIb17TSB9eumVcKkY=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook4
    nodejs_24
    npmHooks.npmConfigHook
    cargo-tauri.hook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    nodejs_24
    glib-networking
    openssl
    gtk3
    glib
    gdk-pixbuf
    cairo
    pango
    libx11
    libxi
    libxcursor
    libxext
    libxrandr
    libxrender
    libxcb
    libxfixes
    libxkbcommon
    vulkan-loader
    libjpeg
    libpng
    zlib
    libGL
    dbus
    gvfs
    libheif
    onnxruntime
    wrapGAppsHook4
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    libappindicator
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  # Set HOME for npm to avoid permission issues and add node_modules to path
  preBuild = ''
    export PATH="$PWD/node_modules/.bin:$PATH"

    # Configure Tauri to use lowercase binary name
    substituteInPlace src-tauri/tauri.conf.json \
      --replace-fail '  "identifier": "io.github.CyberTimon.RapidRAW",' '  "identifier": "io.github.CyberTimon.RapidRAW", "mainBinaryName": "rapidraw",'

    # Disable downloading of ONNX runtime library this is correctly linked during postInstall
    substituteInPlace src-tauri/build.rs \
      --replace-fail 'if !is_valid' 'if false'
  '';

  # Fix dyld error about onnxruntime not being loaded on darwin during cargo test
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export DYLD_LIBRARY_PATH="${onnxruntime}/lib:$DYLD_LIBRARY_PATH"
  '';

  dontWrapGApps = true;

  env = {
    ORT_STRATEGY = "system";
  };

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # Patch the .desktop file to set the Categories field
      sed -i '/^Categories=/c\Categories=Graphics;Photography' "$out/share/applications/RapidRAW.desktop"

      # Ensure the resources directory exists before linking
      mkdir -p $out/lib/RapidRAW/resources

      # link the .so file
      ln -sf ${onnxruntime}/lib/libonnxruntime.so $out/lib/RapidRAW/resources/libonnxruntime.so
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # The binary links against @rpath/libonnxruntime.*.dylib but has no LC_RPATH entries
      install_name_tool -add_rpath "${onnxruntime}/lib" "$out/Applications/RapidRAW.app/Contents/MacOS/rapidraw"
      # The app also dlopen()s libonnxruntime.dylib at a hardcoded path inside the bundle
      mkdir -p "$out/Applications/RapidRAW.app/Contents/Resources/resources"
      ln -sf ${onnxruntime}/lib/libonnxruntime.dylib "$out/Applications/RapidRAW.app/Contents/Resources/resources/libonnxruntime.dylib"
    '';

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapGApp $out/bin/rapidraw \
        --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
        --set ORT_STRATEGY "system"
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapGApp "$out/Applications/RapidRAW.app/Contents/MacOS/rapidraw" \
        --set ORT_STRATEGY "system"
    '';

  meta = {
    description = "Blazingly-fast, non-destructive, and GPU-accelerated RAW image editor built with performance in mind";
    homepage = "https://github.com/CyberTimon/RapidRAW";
    license = lib.licenses.agpl3Only;
    mainProgram = "rapidraw";
    maintainers = with lib.maintainers; [ taciturnaxolotl ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
