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
  version = "0.9-unstable-2025-02-07";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBHardwareSyncPlugin";
    rev = "506f206fc14a6967528158c9ac1376c9463549e6";
    hash = "sha256-7RrNVqHV2CDTHWtCaDyDoTujyuXNIjZobsnemTpkgKI=";
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

  meta = {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin";
    description = "Sync your ARGB devices colors with hardware measures (CPU, GPU, fan speed, etc...)";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      fgaz
      liberodark
    ];
  };
})
