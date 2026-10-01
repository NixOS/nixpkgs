{
  lib,
  rustPlatform,
  fetchFromGitHub,
  makeDesktopItem,
  wrapGAppsHook3,
  nodejs,
  pkg-config,
  llvmPackages,
  cups,
  libayatana-appindicator,
  librsvg,
  openssl,
  webkitgtk_4_1,
  xdotool,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "photosuite";
  version = "0.9.15";

  src = fetchFromGitHub {
    owner = "eolix";
    repo = "photosuite";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-O9VHpiAfgkamABBmKC7vEf/uO990+Q2zSgXQRe1MhW0=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-q9QRmI3pSP+MB9tGih05376IE3/X55PMzrJ0nwJIh60=";
  __structuredAttrs = true;

  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${cups.dev}/include -isystem ${llvmPackages.stdenv.cc.libc.dev}/include";

  nativeBuildInputs = [
    nodejs
    pkg-config
    wrapGAppsHook3
    llvmPackages.libclang
  ];

  buildInputs = [
    cups
    libayatana-appindicator
    librsvg
    openssl
    webkitgtk_4_1
    xdotool
  ];

  postPatch = ''
    node scripts/repair-vendor-symlinks.mjs src
  '';

  postInstall = ''
    install -Dm644 src-tauri/icons/128x128.png \
      $out/share/icons/hicolor/128x128/apps/photosuite.png
    install -Dm644 ${
      makeDesktopItem {
        name = "photosuite";
        desktopName = "PhotoSuite";
        comment = "Advanced image editor";
        exec = "photosuite";
        icon = "photosuite";
        categories = [
          "Graphics"
          "2DGraphics"
          "RasterGraphics"
        ];
      }
    }/share/applications/photosuite.desktop \
      $out/share/applications/photosuite.desktop
  '';

  meta = {
    description = "Advanced desktop image editor";
    homepage = "https://github.com/eolix/photosuite";
    license = lib.licenses.gpl3Only;
    mainProgram = "photosuite";
    platforms = lib.platforms.linux;
  };
})
