{ lib
, stdenv
, fetchFromGitHub
, cmake
, codec2
, libsamplerate
, libsndfile
, lpcnetfreedv
, portaudio
, speexdsp
, hamlib
, wxGTK31-gtk3
}:

stdenv.mkDerivation rec {
  pname = "freedv";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "drowe67";
    repo = "freedv-gui";
    rev = "v${version}";
    sha256 = "1dzhf944vgla9a5ilcgwivhzgdbfaknqnwbpb071a0rz8rajnv0q";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    codec2
    libsamplerate
    libsndfile
    lpcnetfreedv
    portaudio
    speexdsp
    hamlib
    wxGTK31-gtk3
  ];

  cmakeFlags = [
    "-DUSE_INTERNAL_CODEC2:BOOL=FALSE"
    "-DUSE_STATIC_DEPS:BOOL=FALSE"
  ];

  meta = with lib; {
    homepage = "https://freedv.org/";
    description = "Digital voice for HF radio";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ mvs ];
  };
}
