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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lifeograph";
  version = "3.0.3";

  src = fetchgit {
    url = "https://git.launchpad.net/lifeograph";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VaDxmbTVx6wiFMDRYuBM5Y4oPODWPTm8QP6zpT+yBOY=";
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
    libchamplain
    libshumate
  ];

  meta = {
    homepage = "https://lifeograph.sourceforge.net/doku.php?id=start";
    description = "Off-line and private journal and note taking application";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ emaryn ];
    mainProgram = "lifeograph";
    platforms = lib.platforms.linux;
  };
})
