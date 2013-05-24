{ stdenv, fetchurl, libX11, imlib2, giflib }:

stdenv.mkDerivation {
  name = "sxiv-1.1";

  src = fetchurl {
    url = "https://github.com/muennich/sxiv/archive/v1.1.tar.gz";
    name = "sxiv-1.1.tar.gz";
    sha256 = "0gsqwa1yacsig7ycjrw0sjyrsa9mynfzzbwm1vp2bgk4s9hb08kx";
  };

  buildInputs = [ libX11 imlib2 giflib ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
  };
}
