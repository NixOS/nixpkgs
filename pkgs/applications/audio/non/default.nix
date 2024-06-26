{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  python3,
  cairo,
  libjpeg,
  ntk,
  libjack2,
  libsndfile,
  ladspaH,
  liblo,
  libsigcxx,
  lrdf,
  wafHook,
}:

stdenv.mkDerivation {
  pname = "non";
  version = "unstable-2021-01-28";
  src = fetchFromGitHub {
    owner = "linuxaudio";
    repo = "non";
    rev = "cdad26211b301d2fad55a26812169ab905b85bbb";
    sha256 = "sha256-iMJNMDytNXpEkUhL0RILSd25ixkm8HL/edtOZta0Pf4=";
  };

  nativeBuildInputs = [
    pkg-config
    wafHook
  ];
  buildInputs = [
    python3
    cairo
    libjpeg
    ntk
    libjack2
    libsndfile
    ladspaH
    liblo
    libsigcxx
    lrdf
  ];

  env.CXXFLAGS = "-std=c++14";

  meta = {
    description = "Lightweight and lightning fast modular Digital Audio Workstation";
    homepage = "http://non.tuxfamily.org";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nico202 ];
  };
}
