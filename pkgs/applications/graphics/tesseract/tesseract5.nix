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

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.5.1";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-bLTYdT9CNfgrmmjP6m0rRqJDHiSOkcuGVCFwPqT12jk=";
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
}
