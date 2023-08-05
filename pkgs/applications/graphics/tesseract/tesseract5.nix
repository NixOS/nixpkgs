{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkg-config
, leptonica, libpng, libtiff, icu, pango, opencl-headers, fetchpatch
, Accelerate, CoreGraphics, CoreVideo
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.3.2";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-49pTs9r9ebERC0S663+h/f70s693zDseKRziafCIaTo=";
  };

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
