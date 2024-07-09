{ lib
, mkDerivation
, extra-cmake-modules
, kirigami2
, ktextwidgets
, libksane
, qtquickcontrols2
, kpurpose
, kquickimageedit
}:

mkDerivation {
  pname = "skanpage";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kirigami2
    ktextwidgets
    libksane
    qtquickcontrols2
    kpurpose
    kquickimageedit
  ];

  meta = with lib; {
    description = "KDE utility to scan images and multi-page documents";
    mainProgram = "skanpage";
    homepage = "https://apps.kde.org/skanpage";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
