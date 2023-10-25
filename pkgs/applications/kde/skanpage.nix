{ lib
, mkDerivation
, fetchurl
, extra-cmake-modules
, kirigami2
, ktextwidgets
, libksane
, qtquickcontrols2
, kpurpose
}:

mkDerivation rec {
  pname = "skanpage";

  nativeBuildInputs = [ extra-cmake-modules ];

  buildInputs = [
    kirigami2
    ktextwidgets
    libksane
    qtquickcontrols2
    kpurpose
  ];

  meta = with lib; {
    description = "KDE utility to scan images and multi-page documents";
    homepage = "https://apps.kde.org/skanpage";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
