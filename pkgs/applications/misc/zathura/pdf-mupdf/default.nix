{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  desktop-file-utils,
  appstream,
  zathura_core,
  girara,
  mupdf,
  glib,
  cairo,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2026.07.18";
  pname = "zathura-pdf-mupdf";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-pdf-mupdf";
    tag = finalAttrs.version;
    hash = "sha256-zHqs+7Pu6ps4+PV/3rW1FETQVcat2QlPpUvwQXPHgV8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream
  ];

  buildInputs = [
    zathura_core
    girara
    mupdf
    glib
    cairo
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://pwmt.org/projects/zathura-pdf-mupdf/";
    description = "Zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mithicspirit ];
  };
})
