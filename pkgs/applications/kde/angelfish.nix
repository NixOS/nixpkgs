{ lib
, mkDerivation
, cargo
, cmake
, corrosion
, extra-cmake-modules
<<<<<<< HEAD
, futuresql
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami-addons
, kirigami2
, knotifications
, kpurpose
, kwindowsystem
<<<<<<< HEAD
, qcoro
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, qtfeedback
, qtquickcontrols2
, qqc2-desktop-style
, qtwebengine
, rustPlatform
, rustc
, srcs

# provided as callPackage input to enable easier overrides through overlays
<<<<<<< HEAD
, cargoSha256 ? "sha256-FI94TU3MgIl1tcjwJnzb2PKO1rbZ3uRB1mzXXkNU95I="
=======
, cargoSha256 ? "sha256-whMfpElpFB7D+dHHJrbwINFL4bVpHTlcZX+mdBfiqEE="
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation rec {
  pname = "angelfish";

  cargoDeps = rustPlatform.fetchCargoTarball {
    # include version in the name so we invalidate the FOD
    name = "${pname}-${srcs.angelfish.version}";
    inherit (srcs.angelfish) src;
    sha256 = cargoSha256;
  };

  nativeBuildInputs = [
    cmake
    corrosion
    extra-cmake-modules
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
<<<<<<< HEAD
    futuresql
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami-addons
    kirigami2
    knotifications
    kpurpose
    kwindowsystem
<<<<<<< HEAD
    qcoro
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    qtfeedback
    qtquickcontrols2
    qqc2-desktop-style
    qtwebengine
  ];

  meta = with lib; {
    description = "Web browser for Plasma Mobile";
    homepage = "https://invent.kde.org/plasma-mobile/angelfish";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
