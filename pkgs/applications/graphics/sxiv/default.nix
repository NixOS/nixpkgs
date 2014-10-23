{ stdenv, fetchurl, libX11, imlib2, giflib }:

stdenv.mkDerivation rec {
  name = "sxiv-1.2";

  src = fetchurl {
    url = "https://github.com/muennich/sxiv/archive/v1.2.tar.gz";
    name = "${name}.tar.gz";
    sha256 = "1wwcxy2adc67xd8x6c2sayy1cjcwrv2lvv1iwln7y4w992gbcxmc";
  };

  patches = [ ./146.patch ];

  buildInputs = [ libX11 imlib2 giflib ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = {
    description = "Simple X Image Viewer";
    homepage = "https://github.com/muennich/sxiv";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
  };
}
