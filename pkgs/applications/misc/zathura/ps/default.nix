{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  libspectre,
  gettext,
  desktop-file-utils,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-ps";
  version = "0.2.8";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-ps/download/zathura-ps-${finalAttrs.version}.tar.xz";
    hash = "sha256-B8pZT3J3+YdtADgEhBg0PqKWQCjpPJD5Vp7/NqiTLko=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream-glib
  ];

  buildInputs = [
    libspectre
    zathura_core
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-ps/";
    description = "Zathura PS plugin";
    longDescription = ''
      The zathura-ps plugin adds PS support to zathura by using the
      libspectre library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
