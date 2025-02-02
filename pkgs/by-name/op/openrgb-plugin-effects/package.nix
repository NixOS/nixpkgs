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

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "Effects plugin for OpenRGB";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
})
