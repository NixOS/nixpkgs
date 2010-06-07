{stdenv, fetchurl, libX11, libXinerama, patches ? []}:

stdenv.mkDerivation rec {
  name = "dwm-5.8.2";
 
  src = fetchurl {
    url = "http://dl.suckless.org/dwm/${name}.tar.gz";
    sha256 = "0rlv72fls2k4s48a0mw7mxa05d4qdxgs8pqbkyqkpzz3jb3kn965";
  };
 
  buildInputs = [ libX11 libXinerama ];
 
  prePatch = ''sed -i "s@/usr/local@$out@" config.mk'';

  # Allow users set their own list of patches
  inherit patches;

  buildPhase = " make ";
 
  meta = {
    homepage = "www.suckless.org";
    description = "dynamic window manager for X";
    license="MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };
}
