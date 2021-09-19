{ lib, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, jack2
, cairo
, liblo
, libsndfile
, libsamplerate
, ntk
, cmake
, lv2
, gnumake
, libXdmcp
, libxcb
}:

stdenv.mkDerivation rec {
  pname = "fabla";
  version = "1.3.2";

  src = fetchTarball {
#    owner = "openAVproductions";
#    repo = "openAV-Luppp";
#    rev = "release-${version}";
    url = "https://github.com/openAVproductions/openAV-Fabla/tarball/master";
    sha256 = "1f6sh7y855xvhcnc9r73pdxnldwcs6f9ssvbypkwi5alkfa9zf14";
  };

#  configurePhase = ''
#
#   mkdir build
#   cd build
#   cmake ..
#  '';
# buildPhase = ''
#   make -j4
#   make install
#   '';
#
  nativeBuildInputs = [
    cmake
    gnumake
    pkg-config
  ];

  buildInputs = [
#    openav_ctlra
    lv2
    jack2
    cairo
    liblo
    libsndfile
    libsamplerate
    ntk
    libXdmcp
    libxcb
  ];

  meta = with lib; {
    homepage = "http://openavproductions.com/fabla/"; 
    description = "Fabla is an open-source LV2 drum sampler plugin instrument.";
    license = licenses.gpl2;
    maintainers = with maintainers; [ prusnak horhik];
    platforms = platforms.linux;
  };
}
