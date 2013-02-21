{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.2.1";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "d8bb3c9e30244a0733e49740ee2dd099ce39fa16f2c320af27a0c09d9a25bcc3";
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
    license = "free";
    platforms = stdenv.lib.platforms.linux;
  };
}

