{
  lib,
  mkDerivation,
  cmake,
  extra-cmake-modules,
  kconfig,
  kcoreaddons,
  ki18n,
  knotifications,
  mauiman,
  qtquickcontrols2,
  qtx11extras,
}:

mkDerivation {
  pname = "mauikit";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
    knotifications
    mauiman
    qtquickcontrols2
    qtx11extras
  ];

  meta = with lib; {
    homepage = "https://mauikit.org/";
    description = "Free and modular front-end framework for developing fast and compelling user experiences";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
