{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, kcoreaddons
, ki18n
, kirigami2
, mauikit
, mauikit-filebrowsing
, qtquickcontrols2
, libgit2
, mauikit-texteditor
, sonnet
}:

mkDerivation {
  pname = "bonsai";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcoreaddons
    ki18n
    kirigami2
    libgit2
    mauikit
    mauikit-filebrowsing
    mauikit-texteditor
    qtquickcontrols2
    sonnet
  ];

  meta = with lib; {
    description = "Mobile Git repository manager";
    homepage = "https://invent.kde.org/maui/bonsai";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
