{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pngcheck";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "pnggroup";
    repo = "pngcheck";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7e+jFO09/23CdWipKZMQYq5nQNHarTpMtP3cBm2xAds=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ zlib ];

  cmakeFlags = [
    "-DPNGCHECK_ENABLE_AUX_TOOLS=ON"
  ];

  meta = with lib; {
    homepage = "https://www.libpng.org/pub/png/apps/pngcheck.html";
    description = "Verifies the integrity of PNG, JNG and MNG files";
    license = licenses.free;
    platforms = platforms.unix;
    maintainers = with maintainers; [ starcraft66 ];
    mainProgram = "pngcheck";
  };
})
