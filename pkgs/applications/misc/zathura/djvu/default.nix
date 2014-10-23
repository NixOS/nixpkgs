{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.2.4";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1g1lafmrjbx0xv7fljdmyqxx0k334sq4q6jy4a0q5xfrgz0bh45c";
  };

  buildInputs = [ pkgconfig djvulibre gettext zathura_core gtk girara ];

  patches = [ ./gtkflags.patch ];

  makeFlags = "PREFIX=$(out) PLUGINDIR=$(out)/lib";

  meta = {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura DJVU plugin";
    longDescription = ''
	  The zathura-djvu plugin adds DjVu support to zathura by using the
	  djvulibre library.
    '';
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}

