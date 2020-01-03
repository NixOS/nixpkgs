{ mkDerivation
, lib
, extra-cmake-modules
, breeze-icons
, breeze-qt5
, kdoctools
, kconfig
, kcrash
, kguiaddons
, kiconthemes
, ki18n
, kinit
, kdbusaddons
, knotifications
, knewstuff
, karchive
, knotifyconfig
, kplotting
, ktextwidgets
, mlt
, shared-mime-info
, libv4l
, kfilemetadata
, ffmpeg-full
, frei0r
, phonon-backend-gstreamer
, qtdeclarative
, qtquickcontrols
, qtscript
, qtwebkit
, rttr
, kpurpose
, kdeclarative
}:

mkDerivation {
  name = "kdenlive";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    breeze-icons
    breeze-qt5
    kconfig
    kcrash
    kdbusaddons
    kfilemetadata
    kguiaddons
    ki18n
    kiconthemes
    kinit
    knotifications
    knewstuff
    karchive
    knotifyconfig
    kplotting
    ktextwidgets
    mlt
    phonon-backend-gstreamer
    qtdeclarative
    qtquickcontrols
    qtscript
    qtwebkit
    shared-mime-info
    libv4l
    ffmpeg-full
    frei0r
    rttr
    kpurpose
    kdeclarative
  ];
  patches = [ ./mlt-path.patch ];
  inherit mlt;
  postPatch =
    # Module Qt5::Concurrent must be included in `find_package` before it is used.
    ''
      sed -i CMakeLists.txt -e '/find_package(Qt5 REQUIRED/ s|)| Concurrent)|'
      substituteAllInPlace src/kdenlivesettings.kcfg
    '';
  meta = {
    license = with lib.licenses; [ gpl2Plus ];
  };
}
