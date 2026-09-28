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
  libarchive,
  girara,
  gtk4,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zathura-cb";
  version = "2026.07.18";

  src = fetchFromGitHub {
    owner = "pwmt";
    repo = "zathura-cb";
    tag = finalAttrs.version;
    hash = "sha256-zZ5iqSSzZqhMI1VfQI9ChV2b6cDMM2UnVXrvxjD55zg=";
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
    libarchive
    girara
    gtk4
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
    maintainers = with lib.maintainers; [
      jlesquembre
      mithicspirit
    ];
  };
})
