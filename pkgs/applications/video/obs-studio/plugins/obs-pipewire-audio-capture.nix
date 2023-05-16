{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, obs-studio
, pipewire
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "obs-pipewire-audio-capture";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = pname;
<<<<<<< HEAD
    rev = version;
=======
    rev = "${version}";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    sha256 = "sha256-gcOH8gJuP03MxhJbgl941yTtm2XIHmqHWVwkRCVATkQ=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ obs-studio pipewire ];

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-Wno-dev"
  ];

  preConfigure = ''
    cp ${obs-studio.src}/cmake/external/ObsPluginHelpers.cmake cmake/FindLibObs.cmake
  '';

  meta = with lib; {
    description = " Audio device and application capture for OBS Studio using PipeWire ";
    homepage = "https://github.com/dimtpap/obs-pipewire-audio-capture";
    maintainers = with maintainers; [ Elinvention ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
