{ stdenv
, lib
, cmake
, fetchFromGitHub
, pkg-config
, fftwFloat
, mbedtls
, boost
, lksctp-tools
, libconfig
, pcsclite
, uhd
, soapysdr-with-plugins
, libbladeRF
, zeromq
}:

stdenv.mkDerivation rec {
  pname = "srsran";
  version = "23.04";

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsran";
    rev = "release_${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "sha256-k2KUejn2eBFGknVQCHeYuZd4UUC2Jv0WEI9le9fYoFE=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    fftwFloat
    mbedtls
    boost
    libconfig
    lksctp-tools
    pcsclite
    uhd
    soapysdr-with-plugins
    libbladeRF
    zeromq
  ];

  meta = with lib; {
    homepage = "https://www.srslte.com/";
    description = "Open-source 4G and 5G software radio suite.";
    license = licenses.agpl3;
    platforms = with platforms; linux ;
    maintainers = with maintainers; [ hexagonal-sun ];
  };
}
