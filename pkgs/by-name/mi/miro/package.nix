{
  lib,
  rustPlatform,
  fetchFromGitHub,
  libcosmicAppHook,
  pkg-config,
  fontconfig,
  freetype,
  gumbo,
  harfbuzz,
  jbig2dec,
  lcms,
  libjpeg,
  openjpeg,
  zlib,
  leptonica,
  tesseract,
  libarchive,
  brotli,
  versionCheckHook,
  gtk3,
  xdotool,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miro";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "vincent-uden";
    repo = "miro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-crDsYiuAOp4uJpwn1eVB3gOedkn+IHHxerKAX8AcvUc=";
  };

  cargoHash = "sha256-ww0VUDCKslHoOhnBlAQu4vO8M3hX78wEgl16vBLp4KE=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    libcosmicAppHook
    pkg-config
  ];

  buildInputs = [
    fontconfig
    freetype
    gumbo
    harfbuzz
    jbig2dec
    lcms
    libjpeg
    openjpeg
    zlib
    leptonica
    tesseract
    libarchive
    brotli
    gtk3
    xdotool
  ];

  env = {
    # https://github.com/messense/mupdf-rs/blob/d03a17106e0164fe84c6e7fbe415cda20297825f/mupdf-sys/make.rs#L93
    CARGO_FEATURE_SYS_LIB_FREETYPE = true;
    CARGO_FEATURE_SYS_LIB_GUMBO = true;
    CARGO_FEATURE_SYS_LIB_HARFBUZZ = true;
    CARGO_FEATURE_SYS_LIB_JBIG2DEC = true;
    # CARGO_FEATURE_SYS_LIB_JPEGXR = true;
    CARGO_FEATURE_SYS_LIB_LCMS2 = true;
    CARGO_FEATURE_SYS_LIB_LIBJPEG = true;
    CARGO_FEATURE_SYS_LIB_OPENJPEG = true;
    CARGO_FEATURE_SYS_LIB_ZLIB = true;
    CARGO_FEATURE_SYS_LIB_TESSERACT = true;
    CARGO_FEATURE_SYS_LIB_LEPTONICA = true;
    CARGO_FEATURE_SYS_LIB_LIBARCHIVE = true;
    # CARGO_FEATURE_SYS_LIB_ZXINGCPP = true;
    CARGO_FEATURE_SYS_LIB_BROTLI = true;
  };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native PDF viewer (Wayland/X11) with configurable keybindings";
    homepage = "https://github.com/vincent-uden/miro";
    changelog = "https://github.com/vincent-uden/miro/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "miro-pdf";
  };
})
