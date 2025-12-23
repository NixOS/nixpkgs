{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  libspectre,
  gettext,
  desktop-file-utils,
  appstream,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-ps";
  version = "0.2.9";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-ps";
    tag = finalAttrs.version;
    hash = "sha256-YQtMfHhPAe8LtJfcw8LRGe5LvtPY7DjYKFaWOYlveeI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    desktop-file-utils
    appstream
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
