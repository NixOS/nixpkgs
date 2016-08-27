{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.2.5";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "03cw54d2fipvbrnbqy0xccqkx6s77dyhyymx479aj5ryy4513dq8";
  };

  buildInputs = [ pkgconfig djvulibre gettext zathura_core gtk girara ];

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

