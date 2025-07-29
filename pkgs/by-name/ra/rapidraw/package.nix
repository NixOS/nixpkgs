{
  lib,
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
  xorg,
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
  nodejs_20,
  npmHooks,
  cargo-tauri,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rapidraw";
  version = "1.2.12";

  src = fetchFromGitHub {
    owner = "CyberTimon";
    repo = "RapidRAW";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KF7HXkR6Iuwxh/S3M3BojzAau/tVE+3Lycp4SYI1GG4=";
  };

  cargoHash = "sha256-3YeAK7FaBs70DqAoQQlCoqakgPUehE83+bedCwFGFVk=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-MULxH6gmHC58XdQe4ePvHcXP7/7fYNHgGHHltkODQ6w=";
  };

  nativeBuildInputs = [
    pkg-config
    makeWrapper
    wrapGAppsHook4
    nodejs_20
    npmHooks.npmConfigHook
    cargo-tauri.hook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    nodejs_20
    glib-networking
    openssl
    webkitgtk_4_1
    gtk3
    glib
    gdk-pixbuf
    libappindicator
    cairo
    pango
    xorg.libX11
    xorg.libXi
    xorg.libXcursor
    xorg.libXext
    xorg.libXrandr
    xorg.libXrender
    xorg.libxcb
    xorg.libXfixes
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
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  # Set HOME for npm to avoid permission issues and add node_modules to path
  preBuild = ''
    export PATH="$PWD/node_modules/.bin:$PATH"

    # Configure Tauri to use lowercase binary name
    substituteInPlace src-tauri/tauri.conf.json \
      --replace '  "identifier": "com.rapidraw.app",' '  "identifier": "com.rapidraw.app", "mainBinaryName": "rapidraw",'
  '';

  dontWrapGApps = true;

  # needs to be declared twice annoyingly
  ORT_STRATEGY = "system";

  postFixup = ''
    wrapGApp $out/bin/rapidraw \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
      --set ORT_STRATEGY "system" \
      --set ORT_DYLIB_PATH "${onnxruntime}/lib/libonnxruntime.so"

    rm -rf $out/lib/RapidRAW/resources
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
