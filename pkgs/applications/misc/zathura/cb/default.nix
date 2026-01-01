{
  stdenv,
  lib,
<<<<<<< HEAD
  fetchFromGitHub,
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  gettext,
  libarchive,
  desktop-file-utils,
<<<<<<< HEAD
  appstream,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  appstream-glib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-cb";
<<<<<<< HEAD
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-cb";
    tag = finalAttrs.version;
    hash = "sha256-Dj398aUQBxOrH5XOC5u/vNkEQ6pa05/EDB5m0EAGAxo=";
=======
  version = "0.1.11";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-cb/download/zathura-cb-${finalAttrs.version}.tar.xz";
    hash = "sha256-TiAepUzcIKkyWMQ1VvY4lEGvmXQN59ymyh/1JBcvvUc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    desktop-file-utils
<<<<<<< HEAD
    appstream
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
