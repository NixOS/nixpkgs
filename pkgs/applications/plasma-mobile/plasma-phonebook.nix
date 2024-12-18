{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kcontacts
, kcoreaddons
, kirigami2
, kirigami-addons
, kpeople
, kpeoplevcard
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "plasma-phonebook";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcontacts
    kcoreaddons
    kirigami2
    kirigami-addons
    kpeople
    kpeoplevcard
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Phone book for Plasma Mobile";
    mainProgram = "plasma-phonebook";
    homepage = "https://invent.kde.org/plasma-mobile/plasma-phonebook";
    # https://invent.kde.org/plasma-mobile/plasma-phonebook/-/commit/3ac27760417e51c051c5dd44155c3f42dd000e4f
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
