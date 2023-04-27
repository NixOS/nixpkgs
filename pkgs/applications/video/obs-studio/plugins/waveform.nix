{ lib
, stdenv
, fetchFromGitHub
, cmake
, fftw
, pkg-config
, obs-studio
}:

stdenv.mkDerivation rec {
  pname = "waveform";
  version = "1.6.1";

  src = fetchFromGitHub {
    fetchSubmodules = true;
    owner = "phandasm";
    repo = "waveform";
    rev = "v${version}";
    sha256 = "sha256-JIgonKitQwc8+1hxyBuHvDNWUZNimv2ChPCVubnbLQc=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ obs-studio fftw ];
  cmakeFlags = [
    #"-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-DBUILTIN_FFTW=ON"
  ];


  #postInstall = ''
  #'';

  meta = with lib; {
    description = "Waveform is an audio spectral analysis plugin for OBS";
    homepage = "https://github.com/phandasm/waveform";
    maintainers = with maintainers; [ takov751 ];
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
