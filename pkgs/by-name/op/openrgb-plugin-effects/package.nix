{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  openal,
  hidapi,
  pipewire,
  pkg-config,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb-plugin-effects";
  version = "1.0rc2";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBEffectsPlugin";
    tag = "release_candidate_${finalAttrs.version}";
    hash = "sha256-0W0hO3PSMpPLc0a7g/Nn7GWMcwBXhOxh1Y2flpdcnfE=";
    fetchSubmodules = true;
  };

  qmakeFlags = [
    "CONFIG+=link_pkgconfig"
    "PKGCONFIG+=libpipewire-0.3"
    "QT_TOOL.lrelease.binary=${lib.getDev qt6Packages.qttools}/bin/lrelease"
  ];

  nativeBuildInputs = [
    pkg-config
    qt6Packages.wrapQtAppsHook
    qt6Packages.qmake
  ];

  buildInputs = [
    qt6Packages.qtbase
    qt6Packages.qt5compat
    glib
    openal
    hidapi
    pipewire
  ];

  meta = {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "Effects plugin for OpenRGB";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.linux;
  };
})
