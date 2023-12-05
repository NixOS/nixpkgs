{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config
, curl, leptonica, libarchive, libpng, libtiff, icu, pango, opencl-headers, fetchpatch
, Accelerate, CoreGraphics, CoreVideo
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.3.3";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-/aGzwm2+0y8fheOnRi/OJXZy3o0xjY1cCq+B3GTzfos=";
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
