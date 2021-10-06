{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kconfig
, kcontacts
, kcoreaddons
, ki18n
, kirigami-addons
, kirigami2
, kitemmodels
, kpublictransport
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "ktrip";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcontacts
    kcoreaddons
    ki18n
    kirigami-addons
    kirigami2
    kitemmodels
    kpublictransport
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Public transport trip planner";
    homepage = "https://apps.kde.org/ktrip/";
    # GPL-2.0-or-later
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
