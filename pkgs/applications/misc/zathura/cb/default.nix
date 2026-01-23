{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  gettext,
  libarchive,
  desktop-file-utils,
  appstream,
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-cb";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-cb";
    tag = finalAttrs.version;
    hash = "sha256-Dj398aUQBxOrH5XOC5u/vNkEQ6pa05/EDB5m0EAGAxo=";
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
