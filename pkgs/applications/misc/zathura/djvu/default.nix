{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gtk,
  zathura_core,
  girara,
  djvulibre,
  gettext,
}:

stdenv.mkDerivation rec {
  pname = "zathura-djvu";
  version = "0.2.9";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "0062n236414db7q7pnn3ccg5111ghxj3407pn9ri08skxskgirln";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];
  buildInputs = [
    djvulibre
    gettext
    zathura_core
    gtk
    girara
  ];

  PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = with lib; {
    homepage = "https://pwmt.org/projects/zathura-djvu/";
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
