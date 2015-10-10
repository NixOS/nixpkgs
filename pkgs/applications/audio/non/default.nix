{ stdenv, fetchgit, cairo, libjpeg, libXft, pkgconfig, python2, ntk, libsndfile, libjack2, libsigcxx, liblo, liblrdf, ladspaH}:

stdenv.mkDerivation rec {
  name = "non-DAW";
  version = "2015-10-28";
  src = fetchgit {
    url = "git://github.com/original-make/non.git";
    sha256 = "13ciagbzm67izb0siyb5xw6n8bla9kkyarqbp9mjzsh87kamv4b8";
  };

    buildInputs = [ stdenv pkgconfig  python2 cairo libjpeg ntk libjack2  libsndfile ladspaH liblrdf liblo libsigcxx];
    configurePhase = ''python waf configure --prefix=$out'';
    buildPhase = ''python waf build'';
    installPhase = ''python waf install'';

  meta = {
    description = "Lightweight and lightning fast Digital Audio Workstation";
    version = "${version}";
    homepage = "http://non.tuxfamily.org/";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}

