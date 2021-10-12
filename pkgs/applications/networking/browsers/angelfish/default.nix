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
  version = "21.08";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-mobile/${version}/angelfish-${version}.tar.xz";
    sha256 = "1gzvlha159bw767mj8lisn89592j4j4dazzfws3v4anddjh60xnh";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "1pbvw9hdzn3i97mahdy9y6jnjsmwmjs3lxfz7q6r9r10i8swbkak";
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
    homepage = "https://invent.kde.org/plasma-mobile/angelfish";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
