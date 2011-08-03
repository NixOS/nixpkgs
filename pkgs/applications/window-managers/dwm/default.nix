{stdenv, fetchurl, libX11, libXinerama, patches ? []}:

stdenv.mkDerivation rec {
  name = "dwm-5.9";
 
  src = fetchurl {
    url = "http://dl.suckless.org/dwm/${name}.tar.gz";
    sha256 = "0cp25zqgaqj5k1mlvgxnc5jqi252chqjc5v0fzpqbhrklaidbk9d";
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
