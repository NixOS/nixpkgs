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
  version = "2026.02.03";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-djvu";
    tag = finalAttrs.version;
    hash = "sha256-5Nl9hK2uOS/NZ4MOxe3m6E9CBt5YKGeh1lZZ5E5bghw=";
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
    maintainers = [ ];
  };
})
