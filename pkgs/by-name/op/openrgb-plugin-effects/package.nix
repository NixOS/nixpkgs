{
  lib,
  stdenv,
  fetchFromGitLab,
  libsForQt5,
  openrgb,
  glib,
  openal,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb-plugin-effects";
  version = "0.9-unstable-2025-02-13";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBEffectsPlugin";
    rev = "713026e96edca2de918f5acf342e92b76ef8584f";
    hash = "sha256-3WGJMXJExU1H8QiZpAA5mqyGZ63Htx5ZIYeI8waSdys=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rm -r OpenRGB
    ln -s ${openrgb.src} OpenRGB
  '';

  nativeBuildInputs = with libsForQt5; [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = with libsForQt5; [
    qtbase
    glib
    openal
  ];

  meta = {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "Effects plugin for OpenRGB";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      fgaz
      liberodark
    ];
  };
})
