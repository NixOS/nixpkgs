{ stdenv, fetchurl, libX11, imlib2, giflib }:

stdenv.mkDerivation {
  name = "sxiv-1.1.1";

  src = fetchurl {
    url = "https://github.com/muennich/sxiv/archive/v1.1.1.tar.gz";
    name = "sxiv-1.1.tar.gz";
    sha256 = "07r8125xa8d5q71ql71s4i1dx4swy8hypxh2s5h7z2jnn5y9nmih";
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
