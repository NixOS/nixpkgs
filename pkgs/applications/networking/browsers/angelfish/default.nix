{ lib
, mkDerivation
, fetchurl
, cmake
, corrosion
, extra-cmake-modules
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kirigami2
, knotifications
, kpurpose
, kwindowsystem
, qtfeedback
, qtquickcontrols2
, qtwebengine
, rustPlatform
}:

mkDerivation rec {
  pname = "angelfish";
  version = "21.06";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-mobile/${version}/angelfish-${version}.tar.xz";
    sha256 = "sha256-iHgmG/DeaUPnRXlVIU8P/oUcYINienYmR2zI9Q4Yd3s=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "0zh0kli7kav18v9znq2f5jklhf3m1kyb41jzmivjx70g9xyfzlwk";
  };

  nativeBuildInputs = [
    cmake
    corrosion
    extra-cmake-modules
  ] ++ (with rustPlatform; [
    cargoSetupHook
    rust.cargo
    rust.rustc
  ]);

  cmakeFlags = [
    "-DRust_CARGO=${rustPlatform.rust.cargo}/bin/cargo"
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami2
    knotifications
    kpurpose
    kwindowsystem
    qtfeedback
    qtquickcontrols2
    qtwebengine
  ];

  meta = with lib; {
    description = "Web browser for Plasma Mobile";
    homepage = "https://apps.kde.org/en/mobile.angelfish";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
