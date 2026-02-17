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
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-ps";
  version = "2026.02.03";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-ps";
    tag = finalAttrs.version;
    hash = "sha256-5i3LvdjcAdofc0oZCBSm2qn/29UR1Yiia3OmVjFC4ZI=";
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

  passthru.updateScript = gitUpdater { };

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
