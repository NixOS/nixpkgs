{
  lib,
  stdenv,
  fetchFromGitLab,
  libsForQt5,
  openrgb,
  glib,
  libgtop,
  lm_sensors,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openrgb-plugin-hardwaresync";
  version = "0.9";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBHardwareSyncPlugin";
    rev = "release_${finalAttrs.version}";
    hash = "sha256-3sQFiqmXhuavce/6v3XBpp6PAduY7t440nXfbfCX9a0=";
  };

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rmdir OpenRGB
    ln -s ${openrgb.src} OpenRGB
    # Remove prebuilt stuff
    rm -r dependencies/lhwm-cpp-wrapper
  '';

  buildInputs = with libsForQt5; [
    qtbase
    glib
    libgtop
    lm_sensors
  ];

  nativeBuildInputs = with libsForQt5; [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin";
    description = "Sync your ARGB devices colors with hardware measures (CPU, GPU, fan speed, etc...)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
})
