{ mkDerivation
, lib
, extra-cmake-modules
, qtquickcontrols2
, kcoreaddons
, kconfig
, ki18n
, kirigami2
}:

mkDerivation {
  pname = "telly-skout";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [ qtquickcontrols2 kcoreaddons kconfig ki18n kirigami2 ];

  meta = {
    description = "A convergent Kirigami TV guide";
    homepage = "https://apps.kde.org/telly-skout/";
    license = lib.licenses.gpl2Plus;
    maintainers = [];
  };
}
