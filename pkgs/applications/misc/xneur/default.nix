args: with args;

stdenv.mkDerivation {
  name="xneur";
  src = fetchurl {
    url = http://dists.xneur.ru/release-0.9.3/tgz/xneur-0.9.3.tar.bz2;
    sha256 = "14pjsxajbibjl70yrvina3kk2114h3i7bgyqlxpjkfcz2778qq12";
  };

  buildInputs = [libX11 pkgconfig pcre GStreamer glib libxml2 aspell
    libXpm];

  inherit aspell;

  preConfigure = ''
    sed -e 's/-Werror//' -i configure
    sed -e 's/for aspell_dir in/for aspell_dir in $aspell /' -i configure
  '';

  meta = {
    description = "xneur is the keyboard layout switcher.";
  };

}
