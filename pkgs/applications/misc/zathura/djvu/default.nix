{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtk3,
  zathura_core,
  girara,
  djvulibre,
  gettext,
  desktop-file-utils,
  appstream,
  appstream-glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-djvu";
  version = "2026.07.18";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-djvu";
    tag = finalAttrs.version;
    hash = "sha256-NKINOR4lptZsXncvra7rGHd+825vLlxF/PEP+q48OH8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream
    appstream-glib
  ];

  buildInputs = [
    djvulibre
    gettext
    zathura_core
    gtk3
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://pwmt.org/projects/zathura-djvu/";
    description = "Zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mithicspirit ];
  };
})
