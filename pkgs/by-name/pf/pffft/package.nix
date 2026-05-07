{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation {
  pname = "pffft";
  version = "0-unstable-2025-06-09";

  src = fetchFromGitHub {
    owner = "marton78";
    repo = "pffft";
    rev = "9ae907aae7a39c08cea398778b9496ba7484423a";
    sha256 = "sha256-+efWiBrJzC188tDSPHMARRDArzx/4E8GYPMfDHAND8k=";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "Pretty Fast FFT (PFFFT) library";
    homepage = "https://github.com/marton78/pffft";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}
