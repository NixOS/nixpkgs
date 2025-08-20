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

  # provided as callPackage input to enable easier overrides through overlays
  cargoSha256 ? "sha256-PSrTo7nGgH0KxA82RlBEwtOu80WMCBeaCxHj3n7SgEE=",
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
