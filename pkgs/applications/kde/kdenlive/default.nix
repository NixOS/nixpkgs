{
  mkDerivation,
  lib,
  extra-cmake-modules,
  breeze-icons,
  breeze-qt5,
  kdoctools,
  kconfig,
  kcrash,
  kguiaddons,
  kiconthemes,
  ki18n,
  kinit,
  kdbusaddons,
  knotifications,
  knewstuff,
  karchive,
  knotifyconfig,
  kplotting,
  ktextwidgets,
  mediainfo,
  mlt,
  shared-mime-info,
  libv4l,
  kfilemetadata,
  ffmpeg-full,
  frei0r,
  phonon-backend-gstreamer,
  qtdeclarative,
  qtmultimedia,
  qtnetworkauth,
  qtquickcontrols2,
  qtscript,
  rttr,
  kpurpose,
  kdeclarative,
  wrapGAppsHook3,
}:

let
  mlt-full = mlt.override {
    ffmpeg = ffmpeg-full;
  };
in
mkDerivation {
  pname = "kdenlive";
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
    mediainfo
    mlt-full
    phonon-backend-gstreamer
    qtdeclarative
    qtmultimedia
    qtnetworkauth
    qtquickcontrols2
    qtscript
    shared-mime-info
    libv4l
    ffmpeg-full
    frei0r
    rttr
    kpurpose
    kdeclarative
    wrapGAppsHook3
  ];
  # Both MLT and FFMpeg paths must be set or Kdenlive will complain that it
  # doesn't find them. See:
  # https://github.com/NixOS/nixpkgs/issues/83885
  patches = [ ./dependency-paths.patch ];

  inherit mediainfo;
  ffmpeg = ffmpeg-full;
  mlt = mlt-full;

  postPatch =
    # Module Qt5::Concurrent must be included in `find_package` before it is used.
    ''
      sed -i CMakeLists.txt -e '/find_package(Qt5 REQUIRED/ s|)| Concurrent)|'
      substituteAllInPlace src/kdenlivesettings.kcfg
    '';

  dontWrapGApps = true;

  # Frei0r path needs to be set too or Kdenlive will complain. See:
  # https://github.com/NixOS/nixpkgs/issues/83885
  # https://github.com/NixOS/nixpkgs/issues/29614#issuecomment-488849325
  qtWrapperArgs = [
    "--set FREI0R_PATH ${frei0r}/lib/frei0r-1"
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://apps.kde.org/kdenlive/";
    description = "Video editor";
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ turion ];
  };
}
