args: with args;

stdenv.mkDerivation {
  name="xneur";
  src = fetchurl {
    url = http://dists.xneur.ru/release-0.9.3/tgz/xneur-0.9.3.tar.bz2;
    sha256 = "14pjsxajbibjl70yrvina3kk2114h3i7bgyqlxpjkfcz2778qq12";
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
