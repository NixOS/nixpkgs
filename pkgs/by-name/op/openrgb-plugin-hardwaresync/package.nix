{
  lib,
  stdenv,
  fetchFromGitLab,
  openrgb,
  glib,
  libgtop,
  lm_sensors,
  pkg-config,
  kdePackages,
  fetchpatch,
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

  patches = [
    # Fix Qt 6 build
    (fetchpatch {
      url = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin/-/commit/62707c260953fb5ac2bb782595c18791bf54ff97.patch";
      hash = "sha256-xMsnVyrn/Cv2x2xQtAnPb5HJc+WolNx4v7h0TkTj9DU=";
    })
  ];

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rmdir OpenRGB
    ln -s ${openrgb.src} OpenRGB
    # Remove prebuilt stuff
    rm -r dependencies/lhwm-cpp-wrapper
  '';

  buildInputs = [
    kdePackages.qtbase
    glib
    libgtop
    lm_sensors
  ];

  nativeBuildInputs = [
    pkg-config
    kdePackages.qmake
    kdePackages.wrapQtAppsHook
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin";
    description = "Sync your ARGB devices colors with hardware measures (CPU, GPU, fan speed, etc...)";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
})
