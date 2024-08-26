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

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-djvu";
  version = "0.2.9";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-djvu/download/zathura-djvu-${finalAttrs.version}.tar.xz";
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

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-djvu/";
    description = "Zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
