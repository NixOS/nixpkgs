{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.2.7";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1sbfdsyp50qc85xc4458sn4w1rv1qbygdwmcr5kjlfpsmdq98vhd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ djvulibre gettext zathura_core gtk girara ];

  patches = [ ./gtkflags.patch ];

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  meta = with stdenv.lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = licenses.zlib;
    platforms = platforms.linux;
    maintainers = with maintainers; [ garbas ];
  };
}

