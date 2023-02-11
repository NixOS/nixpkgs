{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkg-config
, leptonica, libpng, libtiff, icu, pango, opencl-headers, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    hash = "sha256-lu/Y5mlCI8AajhiWaID0fGo5PghEQZdgt2X0K9c/QrE=";
  };

  patches = [
    # https://github.com/tesseract-ocr/tesseract/issues/3447
    (fetchpatch {
      url = "https://github.com/tesseract-ocr/tesseract/commit/dbc79b09d195490dfa3f7d338eadac07ad6683f7.patch";
      sha256 = "sha256-lGlg0etuU4RXfdq1QH2bYObdeGrFHKf9O8zMUAbfNIQ=";
    })
    (fetchpatch {
      url = "https://github.com/tesseract-ocr/tesseract/commit/6dc4b184b1ebf2e68461f6b63f63a033bc7245f7.patch";
      sha256 = "sha256-DwIX3r5NmeajI6WgIVHDbkhLH/ygJIjPO5XrbzWQhSw=";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [
    leptonica
    libpng
    libtiff
    icu
    pango
    opencl-headers
  ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ viric erikarvstedt ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
