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
, qtquickcontrols2
, qtscript
, qtwebkit
, rttr
, kpurpose
, kdeclarative
, wrapGAppsHook
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
    qtquickcontrols2
    qtscript
    qtwebkit
    shared-mime-info
    libv4l
    ffmpeg-full
    frei0r
    rttr
    kpurpose
    kdeclarative
    wrapGAppsHook
  ];
  # Both MLT and FFMpeg paths must be set or Kdenlive will complain that it
  # doesn't find them. See:
  # https://github.com/NixOS/nixpkgs/issues/83885
  patches = [ ./mlt-path.patch ./ffmpeg-path.patch ];
  inherit mlt;
  ffmpeg = ffmpeg-full;
  postPatch =
    # Module Qt5::Concurrent must be included in `find_package` before it is used.
    ''
      sed -i CMakeLists.txt -e '/find_package(Qt5 REQUIRED/ s|)| Concurrent)|'
      substituteAllInPlace src/kdenlivesettings.kcfg
    '';
  # Frei0r path needs to be set too or Kdenlive will complain. See:
  # https://github.com/NixOS/nixpkgs/issues/83885
  # https://github.com/NixOS/nixpkgs/issues/29614#issuecomment-488849325
  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
  ];
  meta = {
    license = with lib.licenses; [ gpl2Plus ];
  };
}
