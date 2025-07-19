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
  gsettings-desktop-schemas,
  nodejs_20,
  npmHooks,
  cargo-tauri,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rapidraw";
  version = "1.2.8";

  src = fetchFromGitHub {
    owner = "CyberTimon";
    repo = "RapidRAW";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yHrLwxuA9DDESJ037ltd1gEBxD6QCuGaJvwZisftr50=";
  };

  cargoHash = "sha256-3YeAK7FaBs70DqAoQQlCoqakgPUehE83+bedCwFGFVk=";

  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) src;
    hash = "sha256-RKSYhvb/bciChIlEyBZzdsBH+6bTUWcWmBMIZ9Ri+0k=";
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
  ];

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";

  # Set HOME for npm to avoid permission issues and add node_modules to path
  preBuild = ''
    export PATH="$PWD/node_modules/.bin:$PATH"

    # Configure Tauri to use lowercase binary name
    substituteInPlace src-tauri/tauri.conf.json \
      --replace '  "identifier": "com.rapidraw.app",' '  "identifier": "com.rapidraw.app", "mainBinaryName": "rapidraw",'

    # Set main binary name to rapidraw
    export TAURI_MAIN_BINARY_NAME="rapidraw"
  '';

  # Post-installation steps to install icons and set up the environment
  # Environment variables for ONNX Runtime and npm build
  CARGO_FEATURE_LOAD_DYNAMIC = "1";
  ORT_STRATEGY = "system";
  XDG_DATA_DIRS = "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}";

  # Prevent network access during build phase
  doCheck = false;

  # Post-installation steps to install icons and set up the environment
  postInstall = ''
    # Copy    # Wrap binary with environment variables to let onyx load
    wrapProgram $out/bin/rapidraw \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath finalAttrs.buildInputs} \
      --set ORT_STRATEGY "system" \
      --prefix XDG_DATA_DIRS : "${gsettings-desktop-schemas}/share/gsettings-schemas/${gsettings-desktop-schemas.name}:${gtk3}/share/gsettings-schemas/${gtk3.name}" \
      --set ORT_DYLIB_PATH "${onnxruntime}/lib"
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
