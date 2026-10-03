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
  poppler,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-pdf-poppler";
  version = "2026.07.18";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-pdf-poppler";
    tag = finalAttrs.version;
    hash = "sha256-yTNox1MH2wYwVUtIEQ3QoC6jKsTQSfQdltQaB+pkAgY=";
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
    poppler
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
    maintainers = with lib.maintainers; [ mithicspirit ];
  };
})
