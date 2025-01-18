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
  Accelerate,
  CoreGraphics,
  CoreVideo,
}:

stdenv.mkDerivation rec {
  pname = "tesseract";
  version = "5.5.0";

  src = fetchFromGitHub {
    owner = "tesseract-ocr";
    repo = "tesseract";
    rev = version;
    sha256 = "sha256-qyckAQZs3gR1NBqWgE+COSKXhv3kPF+iHVQrt6OPi8s=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs =
    [
      curl
      leptonica
      libarchive
      libpng
      libtiff
      icu
      pango
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Accelerate
      CoreGraphics
      CoreVideo
    ];

  passthru.updateScript = nix-update-script { };
  meta = with lib; {
    description = "OCR engine";
    homepage = "https://github.com/tesseract-ocr/tesseract";
    license = licenses.asl20;
    maintainers = with maintainers; [ patrickdag ];
    platforms = platforms.unix;
    mainProgram = "tesseract";
  };
}
