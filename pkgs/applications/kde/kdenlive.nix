{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, qtscript
, kactivities
, kconfig
, kcrash
, kguiaddons
, kiconthemes
, ki18n
, kinit
, kio
, kio-extras
, kwindowsystem
, kdbusaddons
, plasma-framework
, knotifications
, knewstuff
, karchive
, knotifyconfig
, kplotting
, ktextwidgets
, mlt
, shared_mime_info
, libv4l
, kfilemetadata
, ffmpeg
, phonon-backend-gstreamer
, qtquickcontrols
}:

mkDerivation {
  name = "kdenlive";
  patches = [
    ./kdenlive-cmake-concurrent-module.patch
  ];
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
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
    qtquickcontrols
    qtscript
    shared_mime_info
    libv4l
    ffmpeg
  ];
  postPatch =
    # Module Qt5::Concurrent must be included in `find_package` before it is used.
    ''
      sed -i CMakeLists.txt -e '/find_package(Qt5 REQUIRED/ s|)| Concurrent)|'
    '';
  meta = {
    license = with lib.licenses; [ gpl2Plus ];
  };
}
