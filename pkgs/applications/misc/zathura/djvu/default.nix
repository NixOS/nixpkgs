{ stdenv, fetchurl, meson, ninja, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.2.8";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/plugins/download/${name}.tar.xz";
    sha256 = "0axkv1crdxn0z44whaqp2ibkdqcykhjnxk7qzms0dp1b67an9rnh";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ djvulibre gettext zathura_core gtk girara ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with stdenv.lib; {
    homepage = https://pwmt.org/projects/zathura-djvu/;
    description = "A zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}

