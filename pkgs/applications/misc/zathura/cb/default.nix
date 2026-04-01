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
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-cb";
  version = "2026.02.03";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-cb";
    tag = finalAttrs.version;
    hash = "sha256-k5WbJR0PToiSQo00igH/3uHWp7z4dNxwSXiAos6OgJ8=";
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

  passthru.updateScript = gitUpdater { };

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
