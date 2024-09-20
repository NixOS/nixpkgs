{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  poppler,
  desktop-file-utils,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-pdf-poppler";
  version = "0.3.3";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-poppler/download/zathura-pdf-poppler-${finalAttrs.version}.tar.xz";
    hash = "sha256-yBLy9ERv1d4Wc04TwC6pqiW6Tjup9ytzLA/5D5ujSTU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream-glib
    zathura_core
  ];

  buildInputs = [
    poppler
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-pdf-poppler/";
    description = "Zathura PDF plugin (poppler)";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by
      using the poppler rendering library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
