{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  zathura_core,
  girara,
  poppler,
  desktop-file-utils,
  appstream,
  appstream-glib,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-pdf-poppler";
  version = "2026.02.03";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-pdf-poppler";
    tag = finalAttrs.version;
    hash = "sha256-ddW2SepBoR9BpqcAIAONmd2P5AjkhmWyIjIDeTnHO4Y=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    appstream
    appstream-glib
    zathura_core
  ];

  buildInputs = [
    poppler
    girara
  ];

  env.PKG_CONFIG_ZATHURA_PLUGINDIR = "lib/zathura";

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://pwmt.org/projects/zathura-pdf-poppler/";
    description = "Zathura PDF plugin (poppler)";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by
      using the poppler rendering library.
    '';
    license = lib.licenses.zlib;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
})
