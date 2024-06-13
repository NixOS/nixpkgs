{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, curl, leptonica, libarchive, libpng, libtiff, icu, pango, opencl-headers
, Accelerate, CoreGraphics, CoreVideo
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.4.1";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-Yce9DVt1RJZkwN7ZlUE57eHm+cB9z7MbdFv8uCiGapo=";
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
    opencl-headers
  ] ++ lib.optionals stdenv.isDarwin [
    Accelerate
    CoreGraphics
    CoreVideo
  ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anselmschueler ];
    platforms = lib.platforms.unix;
    mainProgram = "tesseract";
  };
}
