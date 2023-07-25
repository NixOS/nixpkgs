{ lib
, mkDerivation
, cargo
, cmake
, corrosion
, extra-cmake-modules
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami-addons
, kirigami2
, knotifications
, kpurpose
, kwindowsystem
, qtfeedback
, qtquickcontrols2
, qqc2-desktop-style
, qtwebengine
, rustPlatform
, rustc
, srcs

# provided as callPackage input to enable easier overrides through overlays
, cargoSha256 ? "sha256-Wthw7foadXO6jYJO1TB4OOYtpwnp8iCdda4tdiYg41A="
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
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami-addons
    kirigami2
    knotifications
    kpurpose
    kwindowsystem
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
