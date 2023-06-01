{ lib
, mkDerivation
, extra-cmake-modules
, wrapQtAppsHook
, kdoctools
, kcoreaddons
, kxmlgui
, kio
, phonon
, taglib
}:

mkDerivation {
  pname = "juk";

  nativeBuildInputs = [
    extra-cmake-modules
    wrapQtAppsHook
    kdoctools
  ];

  buildInputs = [
    kcoreaddons
    kxmlgui
    kio
    phonon
    taglib
  ];

  meta = with lib; {
    homepage = "https://invent.kde.org/multimedia/juk";
    description = "Audio jukebox app, supporting collections of MP3, Ogg Vorbis and FLAC audio files";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ zendo ];
  };
}
