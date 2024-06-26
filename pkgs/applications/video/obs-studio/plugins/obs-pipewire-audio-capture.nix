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
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "dimtpap";
    repo = pname;
    rev = version;
    sha256 = "sha256-dL/+Y1uaD+7EY0UNWbxvh1TTLYfgk07qCqLLGvfzWZk=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config ];
  buildInputs = [ obs-studio pipewire ];

  cmakeFlags = [
    "-DLIBOBS_INCLUDE_DIR=${obs-studio.src}/libobs"
    "-Wno-dev"
  ];

  meta = with lib; {
    description = "Audio device and application capture for OBS Studio using PipeWire";
    homepage = "https://github.com/dimtpap/obs-pipewire-audio-capture";
    maintainers = with maintainers; [ Elinvention ];
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
