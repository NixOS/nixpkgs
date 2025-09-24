{
  lib,
  stdenv,
  fetchgit,
  pkg-config,
  meson,
  ninja,
  wrapGAppsHook4,
  enchant,
  gtkmm4,
  libchamplain,
  libgcrypt,
  shared-mime-info,
  libshumate,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lifeograph";
  version = "3.0.4";

  src = fetchgit {
    url = "https://git.launchpad.net/lifeograph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zo3bMIAao055YhhIFR8AH43lMi6T82PrcYR3Cis/yK0=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    shared-mime-info # for update-mime-database
    wrapGAppsHook4
  ];

  buildInputs = [
    libgcrypt
    enchant
    gtkmm4
    (libchamplain.override { withLibsoup3 = true; })
    libshumate
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    homepage = "https://lifeograph.sourceforge.net/doku.php?id=start";
    description = "Off-line and private journal and note taking application";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ kyehn ];
    mainProgram = "lifeograph";
    platforms = lib.platforms.linux;
  };
})
