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
, qtmultimedia
, qtquickcontrols2
, taglib
, ffmpeg
}:

mkDerivation {
  pname = "clip";

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
    qtmultimedia
    qtquickcontrols2
    taglib
    ffmpeg
  ];

  meta = with lib; {
    description = "Video player and video collection manager";
    mainProgram = "clip";
    homepage = "https://invent.kde.org/maui/clip";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
