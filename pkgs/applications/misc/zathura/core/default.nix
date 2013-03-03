{ stdenv, fetchurl, pkgconfig, gtk, girara, gettext }:

stdenv.mkDerivation rec {

  version = "0.2.2";

  name = "zathura-core-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/download/zathura-${version}.tar.gz";
    sha256 = "1ja2j9ygymr259fxf02j1vkvalypac48gpadq8fn3qbclxxj61k5";
  };

  buildInputs = [ pkgconfig gtk girara gettext ];

  makeFlags = "PREFIX=$(out)";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];

    # Set lower priority in order to provide user with a wrapper script called
    # 'zathura' instead of real zathura executable. The wrapper will build
    # plugin path argument before executing the original.
    priority = 1;
  };
}
