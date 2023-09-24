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
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = pname;
    rev = version;
    sha256 = "sha256-D4ONz/4S5Kt23Tmfa6jvw0X7680R9YDqG8/N6HhIQLE=";
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
