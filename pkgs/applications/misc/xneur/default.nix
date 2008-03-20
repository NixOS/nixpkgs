args: with args;

stdenv.mkDerivation {
  name="xneur";
  src = fetchurl {
    url = "http://dists.xneur.ru/release-0.8.0/tgz/xneur-0.8.0.tar.bz2";
    sha256 = "1f05bm4vqdrlm8rxwgqv89k5lhc236xg841aw4snw514g0hi2sl8";
  };

  buildInputs = [libX11 pkgconfig pcre GStreamer glib libxml2 aspell];

  preConfigure = "sed -e 's/-Werror//' -i configure";

  meta = {
    description = "xneur is the keyboard layout switcher.";
  };

}



