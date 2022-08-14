{ lib, stdenv, fetchFromGitHub, autoreconfHook, autoconf-archive, pkg-config
, leptonica, libpng, libtiff, icu, pango, opencl-headers, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-SvnV6sY+66ozOvgznTE6Gd/GFx/NfugpkpgeANMoUTU=";
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
  ];

  meta = {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ anselmschueler ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
