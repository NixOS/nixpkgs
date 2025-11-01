{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  autoreconfHook,
  pkg-config,
  which,
  gnuplot,
  giflib,
  libjpeg,
  libpng,
  libtiff,
  libwebp,
  openjpeg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "leptonica";
  version = "1.87.0-pre1";

  src = fetchFromGitHub {
    owner = "DanBloomBerg";
    repo = "leptonica";
    rev = version;
    hash = "sha256-AURgV1CINBv1OxUNoWUf7sr6K4j+Zm/qCyxUweBaiNQ=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    giflib
    libjpeg
    libpng
    libtiff
    libwebp
    openjpeg
    zlib
  ];
  enableParallelBuilding = true;

  nativeCheckInputs = [
    which
    gnuplot
  ];

  # Fails on pngio_reg for unknown reason
  doCheck = false; # !stdenv.hostPlatform.isDarwin;

  passthru.updateScript = nix-update-script { };
  meta = {
    maintainers = with lib.maintainers; [ patrickdag ];
    description = "Image processing and analysis library";
    homepage = "http://www.leptonica.org/";
    license = lib.licenses.bsd2; # http://www.leptonica.org/about-the-license.html
    platforms = lib.platforms.unix;
  };
}
