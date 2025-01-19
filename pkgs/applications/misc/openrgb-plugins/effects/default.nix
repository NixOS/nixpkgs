{
  lib,
  stdenv,
  fetchFromGitLab,
  qtbase,
  openrgb,
  glib,
  openal,
  qmake,
  pkg-config,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb-plugin-effects";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBEffectsPlugin";
    rev = "release_${finalAttrs.version}";
    hash = "sha256-8BnHifcFf7ESJgJi/q3ca38zuIVa++BoGlkWxj7gpog=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rm -r OpenRGB
    ln -s ${openrgb.src} OpenRGB
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    glib
    openal
  ];

  meta = {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "Effects plugin for OpenRGB";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.linux;
  };
})
