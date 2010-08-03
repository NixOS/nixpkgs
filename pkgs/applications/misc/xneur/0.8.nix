{ stdenv, fetchurl, pkgconfig, pcre, GStreamer, glib, libxml2, aspell
, imlib2, xorg, xosd }:

stdenv.mkDerivation {
  name = "xneur-0.8.0";
  
  src = fetchurl {
    url = http://dists.xneur.ru/release-0.8.0/tgz/xneur-0.8.0.tar.bz2;
    sha256 = "1f05bm4vqdrlm8rxwgqv89k5lhc236xg841aw4snw514g0hi2sl8";
  };

  buildInputs =
    [ xorg.libX11 pkgconfig pcre GStreamer glib libxml2 aspell
      xorg.libXpm imlib2 xosd xorg.libXt xorg.libXext
    ];

  preConfigure = ''
    sed -e 's/-Werror//' -i configure
    sed -e 's@for aspell_dir in@for aspell_dir in ${aspell} @' -i configure
    sed -e 's@for imlib2_dir in@for imlib2_dir in ${imlib2} @' -i configure
    sed -e 's@for xosd_dir in@for xosd_dir in ${xosd} @' -i configure
  '';

  meta = {
    description = "Utility for switching between keyboard layouts";
  };

}
