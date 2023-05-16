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
<<<<<<< HEAD
  version = "23.04";
=======
  version = "22.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "srsran";
    repo = "srsran";
    rev = "release_${builtins.replaceStrings ["."] ["_"] version}";
<<<<<<< HEAD
    sha256 = "sha256-k2KUejn2eBFGknVQCHeYuZd4UUC2Jv0WEI9le9fYoFE=";
=======
    sha256 = "sha256-O43MXJ6EyKXg7hA1WjW8TqLmAWC+h5RLBGzBO6f/0zo=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
