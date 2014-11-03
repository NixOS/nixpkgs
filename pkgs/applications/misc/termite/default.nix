{ stdenv, fetchgit, pkgconfig, vte, gtk, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "v8";

  src = fetchgit {
    url = "https://github.com/thestinger/termite";
    rev = "7f03ded7308ad0e26b72b150080e4f3e70401815";
    sha256 = "1yj4jvjwv73a02p8a0yip8q39znlhfc9zdr19zm1zik2k4h62c2l";
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
