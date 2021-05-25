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
  version = "21.05";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-mobile/${version}/angelfish-${version}.tar.xz";
    sha256 = "11jd5dwy0xa7kh5z5rc29xy3wfn20hm31908zjax4x83qqjrm075";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "05xvh7yxndqm2bqpm06jsxiv4v02mqxaazll8wllp367qapvr21g";
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
