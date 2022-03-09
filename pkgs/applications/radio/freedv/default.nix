{ lib
, stdenv
, fetchFromGitHub
, cmake
, codec2
, libsamplerate
, libsndfile
, lpcnetfreedv
, portaudio
, pulseaudio
, speexdsp
, hamlib
, wxGTK31-gtk3
}:

stdenv.mkDerivation rec {
  pname = "freedv";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    rev = "v${version}";
    hash = "sha256-0E7r/7+AQRPIFAcE6O1WE0NYiKzAlBR0jKbssqWvRMU=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    codec2
    libsamplerate
    libsndfile
    lpcnetfreedv
    speexdsp
    hamlib
    wxGTK31-gtk3
  ] ++ (if stdenv.isLinux then [ pulseaudio ] else [ portaudio ]);

  cmakeFlags = [
    "-DUSE_INTERNAL_CODEC2:BOOL=FALSE"
    "-DUSE_STATIC_DEPS:BOOL=FALSE"
  ] ++ lib.optionals stdenv.isLinux [ "-DUSE_PULSEAUDIO:BOOL=TRUE" ];

  meta = with lib; {
    homepage = "https://freedv.org/";
    description = "Digital voice for HF radio";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mvs ];
  };
}
