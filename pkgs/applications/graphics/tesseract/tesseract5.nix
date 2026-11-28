{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  curl,
  leptonica,
  libarchive,
  libpng,
  libtiff,
  icu,
  pango,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tesseract";
  version = "5.5.5";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = finalAttrs.version;
    sha256 = "sha256-eK+BDUcwEay7Irev35Byl3YdDuGoYbyRHTe3hulT0H8=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    curl
    leptonica
    libarchive
    libpng
    libtiff
    icu
    pango
  ];

  passthru.updateScript = nix-update-script { };
  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ patrickdag ];
    platforms = lib.platforms.unix;
    mainProgram = "tesseract";
  };
})
