{ stdenv, fetchgit, pkgconfig, vte, gtk, ncurses }:

stdenv.mkDerivation rec {
  name = "termite-${version}";
  version = "v7";

  src = fetchgit {
    url = "https://github.com/thestinger/termite";
    rev = "f0ff025c1bb6a1e3fd83072f00c2dc42a0701f46";
    sha256 = "057yzlqvp84fkmhn4bz9071glj4rh4187xhg48cdppf2w6phcbxp";
  };

  makeFlags = "VERSION=${version}";

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
