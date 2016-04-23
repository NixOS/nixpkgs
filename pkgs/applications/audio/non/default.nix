{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2
, libsndfile, ladspaH, liblrdf, liblo, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2016-04-05";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "16885e69fe865495dc32d869d1454ab148b0dca6";
    sha256 = "1nwzzgcdpbqh5kjvz40yy5nmzvpp8gcr9biyhhwi68s5bsg972ss";
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
