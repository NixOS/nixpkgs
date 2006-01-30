{stdenv, fetchurl, libXaw, xproto, libXt, libX11, libSM, libICE, ncurses}:

stdenv.mkDerivation {
  name = "xterm-208";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xterm.tar.gz;
    md5 = "a062d0b398918015d07c31ecdcc5111a";
  };
  buildInputs = [libXaw xproto libXt libX11 libSM libICE ncurses];
}
