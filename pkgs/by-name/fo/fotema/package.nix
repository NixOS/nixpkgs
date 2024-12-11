{
  lib,
  clangStdenv,
  fetchFromGitHub,
  rustPlatform,

  meson,
  ninja,
  pkg-config,
  cargo,
  rustc,
  appstream,
  desktop-file-utils,
  glib,
  gtk4,
  wrapGAppsHook4,

  libadwaita,
  openssl,
  ffmpeg,
  onnxruntime,
  libshumate,
  opencv,
  libseccomp,
  glycin-loaders,
}:
# Apparently `bindgenHook` + `libclang` is not enough.
# opencv-binding-generator *really* wants to execute `clang` itself...
clangStdenv.mkDerivation (finalAttrs: {
  pname = "fotema";
  version = "1.18.2";

  src = fetchFromGitHub {
    owner = "blissd";
    repo = "fotema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5TWvxuktNWx2DJ1NeKaxO2mjZ/QVEYNWsvK36FGAkU0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-yPrD4Y5L3UXn+ybuS+SMnAulbAmLidYxqH17LDeAp/4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    appstream
    desktop-file-utils # `desktop-file-validate`
    glib # `glib-compile-schemas`
    gtk4 # `gtk-update-icon-cache`
    wrapGAppsHook4
    glycin-loaders.patchHook
  ];

  buildInputs = [
    libadwaita
    openssl
    ffmpeg
    onnxruntime
    libshumate
    opencv
    libseccomp
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
    # Use system OnnxRuntime
    ORT_LIB_LOCATION = "${onnxruntime}/lib";
    ORT_STRATEGY = "system";
  };

  preFixup = ''
    gappsWrapperArgs+=(
      --set ORT_DYLIB_PATH "${onnxruntime}/lib/libonnxruntime.so"
    )
  '';

  meta = {
    description = "Photo gallery for Linux";
    homepage = "https://github.com/blissd/fotema";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "fotema";
  };
})
