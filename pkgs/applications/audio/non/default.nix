{ stdenv, fetchFromGitHub, pkgconfig, python2, cairo, libjpeg, ntk, libjack2, libsndfile,
ladspaH, liblrdf, liblo, libsigcxx
}:

stdenv.mkDerivation rec {
  name = "non-${version}";
  version = "2016-02-07";
  src = fetchFromGitHub {
    owner = "original-male";
    repo = "non";
    rev = "1ef382fbbea598fdb56b25244a703c64ecaf8446";
    sha256 = "1mi3nm0nrrqlk36920irvqf5080lbnj1qc8vnxspgwkjjqgdc22g";
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
