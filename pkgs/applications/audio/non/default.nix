{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2
, libsndfile, ladspaH, liblrdf, liblo, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2016-03-06";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "3946d392216ee999b560d8b7cdee7c4347110e29";
    sha256 = "02vnq2mfimgdrmv3lmz80yif4h9a1lympv0wqc5dr2l0f8amj2fp";
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
