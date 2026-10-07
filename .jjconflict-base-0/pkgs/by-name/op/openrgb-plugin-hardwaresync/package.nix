{
  lib,
  stdenv,
  fetchFromGitLab,
  glib,
  libgtop,
  lm_sensors,
  pkg-config,
  qt6Packages,
  git,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb-plugin-hardwaresync";
  version = "1.0";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBHardwareSyncPlugin";
    tag = "release_${finalAttrs.version}";
    hash = "sha256-aqcx3E3t7WEvOPtS7nfvn9jUURE5MhRcL6+HrkZIY6o=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Remove prebuilt stuff
    rm -r dependencies/lhwm-cpp-wrapper
  '';

  buildInputs = [
    qt6Packages.qtbase
    glib
    libgtop
    lm_sensors
  ];

  nativeBuildInputs = [
    pkg-config
    qt6Packages.qmake
    qt6Packages.wrapQtAppsHook
    git
  ];

  meta = {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin";
    description = "Sync your ARGB devices colors with hardware measures (CPU, GPU, fan speed, etc...)";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.linux;
  };
})
