{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2, libsndfile,
ladspaH, liblrdf, liblo, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2015-10-6";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "88fe7e7b97c97b8733506685f043cbc71b196646";
    sha256 = "15cffp6c14rlssc8g3mrw8zvb88wffb8k8g1vhd299qlcgv7di2h";
  };

    buildInputs = [ pkgconfig python2 cairo libjpeg ntk libjack2 libsndfile
    ladspaH liblrdf liblo libsigcxx
    ];
    configurePhase = ''python waf configure --prefix=$out'';
    buildPhase = ''python waf build'';
    installPhase = ''python waf install'';

  meta = {
    description = "Lightweight and lightning fast modular Digital Audio Workstation";
    homepage = http://non.tuxfamily.org;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
