args: with args;

stdenv.mkDerivation {
  name="xneur";
  src = fetchurl {
    url = "http://dists.xneur.ru/release-0.9.2/tgz/xneur-0.9.2.tar.bz2";
    sha256 = "1zk13ixd82nq8a2rzmmk53xy2iphydf57mfb2ndfil21rkffr0jq";
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



