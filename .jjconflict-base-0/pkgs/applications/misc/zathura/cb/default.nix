{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  gettext,
  libarchive,
  desktop-file-utils,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-cb";
  version = "0.1.11";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-cb/download/zathura-cb-${finalAttrs.version}.tar.xz";
    hash = "sha256-TiAepUzcIKkyWMQ1VvY4lEGvmXQN59ymyh/1JBcvvUc=";
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
    libarchive
    zathura_core
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  meta = {
    homepage = "https://pwmt.org/projects/zathura-cb/";
    description = "Zathura CB plugin";
    longDescription = ''
      The zathura-cb plugin adds comic book support to zathura.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
