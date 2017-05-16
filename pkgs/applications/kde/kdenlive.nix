{ mkDerivation
, lib
, extra-cmake-modules
, kdoctools
, wrapGAppsHook
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
    wrapGAppsHook
  ];
  buildInputs = [
    qtscript
    kconfig
    kcrash
    kguiaddons
    kiconthemes
    kinit
    kdbusaddons
    knotifications
    knewstuff
    karchive
    knotifyconfig
    kplotting
    ktextwidgets
    mlt
    shared_mime_info
    libv4l
    ffmpeg
  ];
  propagatedBuildInputs = [
    kactivities kconfig kcrash kguiaddons kiconthemes kinit kio kio-extras
    kdbusaddons kfilemetadata knotifications knewstuff karchive knotifyconfig
    kplotting ktextwidgets kwindowsystem plasma-framework
    phonon-backend-gstreamer qtquickcontrols shared_mime_info
  ];
  meta = {
    license = with lib.licenses; [ gpl2Plus ];
  };
}
