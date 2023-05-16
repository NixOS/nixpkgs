{ lib
, stdenv
, fetchFromGitLab
<<<<<<< HEAD
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtbase
, openrgb
, glib
, libgtop
, lm_sensors
, qmake
, pkg-config
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "openrgb-plugin-hardwaresync";
<<<<<<< HEAD
  version = "0.9";
=======
  version = "0.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBHardwareSyncPlugin";
    rev = "release_${version}";
<<<<<<< HEAD
    hash = "sha256-3sQFiqmXhuavce/6v3XBpp6PAduY7t440nXfbfCX9a0=";
  };

=======
    hash = "sha256-P+IitP8pQLUkBdMfcNw4fOggqyFfg6lNlnSfUGjddzo=";
  };

  patches = [
    (fetchpatch {
      name = "use-pkgconfig";
      url = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin/-/commit/df2869d679ea43119fb9b174cd0b2cb152022685.patch";
      hash = "sha256-oBtrHwpvB8Z3xYi4ucDSuw+5WijPEbgBW7vLGELFjfw=";
    })
    (fetchpatch {
      name = "add-install-rule";
      url = "https://gitlab.com/OpenRGBDevelopers/OpenRGBHardwareSyncPlugin/-/commit/bfbaa0a32ed05112e0cc8b6b2a8229945596e522.patch";
      hash = "sha256-76UMMzeXnyQRCEE1tGPNR5XSHTT480rQDnJ9hWhfIqY=";
    })
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rmdir OpenRGB
    ln -s ${openrgb.src} OpenRGB
    # Remove prebuilt stuff
    rm -r dependencies/lhwm-cpp-wrapper
  '';

  buildInputs = [
    qtbase
    glib
    libgtop
    lm_sensors
  ];

  nativeBuildInputs = [
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
}
