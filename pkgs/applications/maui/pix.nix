{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, applet-window-buttons
, karchive
, kcoreaddons
, ki18n
, kio
, kirigami2
, mauikit
, mauikit-filebrowsing
, mauikit-imagetools
, qtmultimedia
, qtquickcontrols2
, qtlocation
, exiv2
, kquickimageedit
}:

mkDerivation {
  pname = "pix";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    applet-window-buttons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-filebrowsing
    mauikit-imagetools
    qtmultimedia
    qtquickcontrols2
    qtlocation
    exiv2
    kquickimageedit
  ];

  meta = with lib; {
    description = "Image gallery application";
    homepage = "https://invent.kde.org/maui/pix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
