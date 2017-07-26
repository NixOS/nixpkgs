{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2
, libsndfile, ladspaH, liblrdf, liblo, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2017-03-29";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "10c31e57291b6e42be53371567a722b62b32d220";
    sha256 = "080rha4ffp7qycyg1mqcf4vj0s7z8qfvz6bxm0w29xgg2kkmb3fx";
  };

  buildInputs = [ pkgconfig python2 cairo libjpeg ntk libjack2 libsndfile
    ladspaH liblrdf liblo libsigcxx
  ];
  configurePhase = "python waf configure --prefix=$out";
  buildPhase = "python waf build";
  installPhase = "python waf install";

  meta = {
    description = "Lightweight and lightning fast modular Digital Audio Workstation";
    homepage = http://non.tuxfamily.org;
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ];
  };
}
