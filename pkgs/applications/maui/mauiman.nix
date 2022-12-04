{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kconfig
, kcoreaddons
, ki18n
, knotifications
, qtbase
, qtquickcontrols2
, qtx11extras
}:

mkDerivation {
  pname = "mauiman";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/maui/mauiman";
    description = "Maui Manager Library. Server and public library API";
    maintainers = with maintainers; [ dotlambda ];
  };
}
