{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, curl
, leptonica
, libarchive
, libpng
, libtiff
, icu
, pango
, Accelerate
, CoreGraphics
, CoreVideo
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    hash = "sha256-Yce9DVt1RJZkwN7ZlUE57eHm+cB9z7MbdFv8uCiGapo=";
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
  ] ++ lib.optionals stdenv.isDarwin [
    Accelerate
    CoreGraphics
    CoreVideo
  ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anselmschueler _21CSM ];
    platforms = lib.platforms.unix;
    mainProgram = "tesseract";
  };
}
