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
  version = "5.5.3";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = finalAttrs.version;
    sha256 = "sha256-n+ZtLAVi6+dOusK040i/sSjJqw58Ef62uTeimYbMUHk=";
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
