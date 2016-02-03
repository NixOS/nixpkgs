{ stdenv, fetchgit, pkgconfig, vte, gtk3, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "10";

  src = fetchgit {
    url = "https://github.com/thestinger/termite";
    rev = "refs/tags/v${version}";
    sha256 = "107v59x8q2m1cx1x3i5ciibw4nl1qbq7p58bfw0irkhp7sl7kjk2";
  };

  makeFlags = [ "VERSION=v${version}" "PREFIX=$(out)" ];

  buildInputs = [ pkgconfig vte gtk3 ncurses ];

  meta = with stdenv.lib; {
    description = "A simple VTE-based terminal";
    license = licenses.lgpl2Plus;
    homepage = https://github.com/thestinger/termite/;
    maintainers = [ maintainers.koral ];
    platforms = platforms.all;
  };
}
