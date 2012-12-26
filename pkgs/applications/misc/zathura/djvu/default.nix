{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.1.1";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "04adad7bf1bb392eae4b7b856fe7d40a137f8185ac274289df922758ae827172";
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

