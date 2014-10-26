{ stdenv, fetchgit, pkgconfig, vte, gtk, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "8";

  src = fetchgit {
    url = "https://github.com/thestinger/termite.git";
    rev = "05f3bbf626245a344eb74859ef2aa49f715ebd55";
    sha256 = "01dfg4zg7sgw0cbh0j9sbwdvn43rw7xfcnijfh1dhd6n5yx00b18";
  };

  makeFlags = "VERSION=v${version}";

  buildInputs = [pkgconfig vte gtk ncurses];

  installFlags = "PREFIX=$(out)";

  meta = {
    description = "A simple VTE-based terminal";
    license = stdenv.lib.licenses.lgpl2Plus;
    homepage = https://github.com/thestinger/termite/;
    maintainers = with stdenv.lib.maintainers; [koral];
    platforms = stdenv.lib.platforms.all;
  };
}
