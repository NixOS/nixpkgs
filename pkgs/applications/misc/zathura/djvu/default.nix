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
    hash = "sha256-lub4pu5TIxBzsvcAMmSHL4RQHmPD2nvwWY0EYoawwgA=";
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
    description = "Zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
