{
  lib,
  mkDerivation,
  cargo,
  cmake,
  corrosion,
  extra-cmake-modules,
  fetchpatch2,
  futuresql,
  kconfig,
  kcoreaddons,
  kdbusaddons,
  ki18n,
  kirigami-addons,
  kirigami2,
  knotifications,
  kpurpose,
  kwindowsystem,
  qcoro,
  qtfeedback,
  qtquickcontrols2,
  qqc2-desktop-style,
  qtwebengine,
  rustPlatform,
  rustc,
  srcs,
}:

mkDerivation rec {
  pname = "angelfish";

  patches = [
    (fetchpatch2 {
      name = "fix-build-with-corrosion-0.5.patch";
      url = "https://invent.kde.org/network/angelfish/-/commit/b04928e3b62a11b647622b81fb67b7c0db656ac8.patch";
      hash = "sha256-9rpkMKQKrvGJFIQDwSIeeZyk4/vd348r660mBOKzM2E=";
    })
  ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    # include version in the name so we invalidate the FOD
    name = "${pname}-${srcs.angelfish.version}";
    inherit (srcs.angelfish) src;
    hash = "sha256-M3CtP7eWqOxMvnak6K3QvB/diu4jAfMmlsa6ySFIHCU=";
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
    futuresql
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kirigami-addons
    kirigami2
    knotifications
    kpurpose
    kwindowsystem
    qcoro
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
