{ stdenv, fetchgit, pkgconfig, vte, gtk, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "9";

  src = fetchgit {
    url = "https://github.com/thestinger/termite";
    rev = "refs/tags/v${version}";
    sha256 = "0bnzfjk5yl5i96v5jnlvrz0d1jcp5lal6ppl7y8wx13166i6sdnh";
  };

  makeFlags = "VERSION=v${version}";

  buildInputs = [pkgconfig vte gtk ncurses];

  installFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "A simple VTE-based terminal";
    license = licenses.lgpl2Plus;
    homepage = https://github.com/thestinger/termite/;
    maintainers = [ maintainers.koral ];
    platforms = platforms.all;
  };
}
