{ stdenv, fetchgit, autoconf, automake, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  name = "evtest-1.31";

  preConfigure = "autoreconf -iv";

  buildInputs = [ autoconf automake pkgconfig libxml2 ];

  src = fetchgit {
    url = "git://anongit.freedesktop.org/evtest";
    rev = "871371806017301373b8b0e5b7e8f168ce1ea13f";
    sha256 = "1hxldlldlrb9lnnybn839a97fpqd1cixbmci2wzgr0rzhjbwhcgp";
  };

  meta = with stdenv.lib; {
    description = "Simple tool for input event debugging";
    license = stdenv.lib.licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
