{ stdenv, fetchurl, meson, ninja, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  pname = "zathura-djvu";
  version = "0.2.9";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/plugins/download/${name}.tar.xz";
    sha256 = "0kl7k4lq97m80gninwm84l7cl2jpkpki59mhy2326xgshc9w0wqd";
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
    maintainers = with maintainers; [ ];
  };
}

