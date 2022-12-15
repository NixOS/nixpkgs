{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kcoreaddons
, ki18n
, kirigami2
, mauikit
, mauikit-filebrowsing
, mauikit-texteditor
, sonnet
, qmltermwidget
}:

mkDerivation {
  pname = "strike";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcoreaddons
    ki18n
    kirigami2
    mauikit
    mauikit-filebrowsing
    mauikit-texteditor
    qmltermwidget
    sonnet
  ];

  meta = with lib; {
    description = "Convergent terminal emulator";
    homepage = "https://invent.kde.org/maui/station";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
