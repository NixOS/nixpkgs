{ stdenv, pkgs, fetchgit}:

stdenv.mkDerivation rec {
  name = "non";
  version = "2015-10-6";
  src = fetchgit {
    url = "git://github.com/original-male/non.git";
    rev = "88fe7e7b97c97b8733506685f043cbc71b196646";
    sha256 = "1v5lks2m27837p84x9ffrl6rgdgx1my29n2cq27ifd13w9y8694s";
  };

    buildInputs = [ pkgs.pkgconfig pkgs.python2 pkgs.cairo pkgs.libjpeg pkgs.ntk pkgs.libjack2 pkgs.libsndfile pkgs.ladspaH pkgs.liblrdf pkgs.liblo pkgs.libsigcxx ];
    configurePhase = ''python waf configure --prefix=$out'';
    buildPhase = ''python waf build'';
    installPhase = ''python waf install'';

  meta = {
    description = "Lightweight and lightning fast modular Digital Audio
Workstation";
    version = "${version}";
    homepage = "http://non.tuxfamily.org/";
    license = stdenv.lib.licenses.lgpl21;
    platforms = stdenv.lib.platforms.linux;
  };
}
