{ lib
, mkDerivation

, cmake
, extra-cmake-modules
, bison
, flex

, gmp
, mpfr

, kconfig
, kcoreaddons
, ki18n
, kirigami2
, kunitconversion
, qtfeedback
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "kalk";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    bison
    flex
  ];

  buildInputs = [
    gmp
    mpfr

    kconfig
    kcoreaddons
    ki18n
    kirigami2
    kunitconversion
    qtfeedback
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Calculator built with kirigami";
    homepage = "https://invent.kde.org/plasma-mobile/kalk";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
