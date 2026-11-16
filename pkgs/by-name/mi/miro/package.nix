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
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "miro";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "vincent-uden";
    repo = "miro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aCXPaUir4sd27S9CEdPbgaas2mstAxONcIWmZMpX6a8=";
  };

  cargoHash = "sha256-/XlkdtZNx05WgdlHZ2WWUrjadiAUJz6x25jSKiO/H34=";

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
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "miro-pdf";
  };
})
