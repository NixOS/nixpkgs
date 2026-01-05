{
  lib,
  stdenv,
  fetchFromGitLab,
  openrgb,
  glib,
  openal,
  pkg-config,
  kdePackages,
  fetchpatch,
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

  patches = [
    # Fix Qt6 issues in OpenRGBPluginsFont.cpp
    (fetchpatch {
      url = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin/-/commit/e952b0ed390045d4f4adec8e74b3126c2f8abcab.patch";
      hash = "sha256-xMsnVyrn/Cv2x2xQtAnPb5HJc+WolNx4v7h0TkTj9DU=";
    })
    ./qt5compat.patch
  ];

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rm -r OpenRGB
    ln -s ${openrgb.src} OpenRGB
  '';

  nativeBuildInputs = [
    pkg-config
    kdePackages.wrapQtAppsHook
    kdePackages.qmake
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qt5compat
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
