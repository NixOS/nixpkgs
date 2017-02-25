{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2
, libsndfile, ladspaH, liblrdf, liblo, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2016-12-07";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "754d113b0e3144a145d50bde8370ff2cae98169c";
    sha256 = "04h67vy966vys6krgjsxd7dph4z46r8c6maw1hascxlasy3bhhk0";
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
