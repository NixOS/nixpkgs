args: with args;

stdenv.mkDerivation {
  name="xneur";
  src = fetchurl {
    url = http://dists.xneur.ru/release-0.8.0/tgz/xneur-0.8.0.tar.bz2;
    sha256 = "1f05bm4vqdrlm8rxwgqv89k5lhc236xg841aw4snw514g0hi2sl8";
  };

  buildInputs = [libX11 pkgconfig pcre GStreamer glib libxml2 aspell
    libXpm imlib2 xosd libXt libXext];

  inherit aspell imlib2 xosd;

  preConfigure = ''
    sed -e 's/-Werror//' -i configure
    sed -e 's/for aspell_dir in/for aspell_dir in $aspell /' -i configure
    sed -e 's/for imlib2_dir in/for imlib2_dir in $imlib2 /' -i configure
    sed -e 's/for xosd_dir in/for xosd_dir in $xosd /' -i configure
  '';

  meta = {
    description = "xneur is the keyboard layout switcher.";
  };

}
