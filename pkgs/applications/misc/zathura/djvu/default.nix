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
  desktop-file-utils,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-djvu";
  version = "0.2.10";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-djvu/download/zathura-djvu-${finalAttrs.version}.tar.xz";
    hash = "sha256-MunYmSmnbNfT/Lr3n0QYaL2r7fFzF9HRhD+qHxkzjZU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream-glib
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
