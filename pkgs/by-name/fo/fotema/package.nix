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
  libglycin,
  wrapGAppsHook4,

  libadwaita,
  openssl,
  ffmpeg,
  onnxruntime,
  libshumate,
  opencv,
  libseccomp,
  glycin-loaders,

  nix-update-script,
}:
# Apparently `bindgenHook` + `libclang` is not enough.
# opencv-binding-generator *really* wants to execute `clang` itself...
clangStdenv.mkDerivation (finalAttrs: {
  pname = "fotema";
  version = "2.4.2";

  src = fetchFromGitHub {
    owner = "blissd";
    repo = "fotema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-g1CxgK8gaX24TFnlGUons3ve8Ow9YaiMh1kMwlcP/F8=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-vA1vB2Lgyo5SfexDC4Ag85nM+/NzsYZNeIH4HmiESHc=";
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
    libglycin.patchVendorHook
  ];

  buildInputs = [
    libadwaita
    openssl
    ffmpeg
    onnxruntime
    libshumate
    opencv
    libseccomp
    libglycin.setupHook
    glycin-loaders
  ];

  strictDeps = true;

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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Photo gallery for Linux";
    homepage = "https://github.com/blissd/fotema";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "fotema";
  };
})
