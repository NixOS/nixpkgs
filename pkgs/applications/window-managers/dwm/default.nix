{stdenv, fetchurl, libX11, libXinerama, patches ? []}:

stdenv.mkDerivation rec {
  name = "dwm-5.7.2";
 
  src = fetchurl {
    url = "http://dl.suckless.org/dwm/${name}.tar.gz";
    sha256 = "1q6dpyi3fx09wxrclfmr4k6516gzd1aj2svyvrayr76sslrzxgrj";
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
