<<<<<<< HEAD
{ mkDerivation, config, lib, fetchurl, cmake, doxygen, extra-cmake-modules, wrapGAppsHook
=======
{ mkDerivation, lib, fetchurl, cmake, doxygen, extra-cmake-modules, wrapGAppsHook
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

# For `digitaglinktree`
, perl, sqlite

, qtbase
, qtxmlpatterns
, qtsvg
, qtwebengine
<<<<<<< HEAD
, qtnetworkauth
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

, akonadi-contacts
, kcalendarcore
, kconfigwidgets
, kcoreaddons
, kdoctools
, kfilemetadata
, knotifications
, knotifyconfig
, ktextwidgets
, kwidgetsaddons
, kxmlgui

, bison
, boost
, eigen
, exiv2
, ffmpeg_4
, flex
, graphviz
, imagemagick
, lcms2
, lensfun
, libgphoto2
, libkipi
, libksane
, liblqr1
, libqtav
, libusb1
, marble
, libGL
, libGLU
, opencv
, pcre
, threadweaver
, x265
, jasper

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, breeze-icons
, oxygen
<<<<<<< HEAD

, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

mkDerivation rec {
  pname   = "digikam";
<<<<<<< HEAD
  version = "8.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/digiKam-${version}.tar.xz";
    hash = "sha256-BQPANORF/0JPGKZxXAp6eb5KXgyCs+vEYaIc7DdFpbM=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    extra-cmake-modules
    kdoctools
    wrapGAppsHook
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_nvcc
  ]);
=======
  version = "7.10.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/digiKam-${version}.tar.xz";
    sha256 = "sha256-o/MPAbfRttWFgivNXr+N9p4P8CRWOnJGLr+AadvaIuE=";
  };

  nativeBuildInputs = [ cmake doxygen extra-cmake-modules kdoctools wrapGAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    bison
    boost
    eigen
    exiv2
    ffmpeg_4
    flex
    graphviz
    imagemagick
    lcms2
    lensfun
    libgphoto2
    libkipi
    libksane
    liblqr1
    libqtav
    libusb1
    libGL
    libGLU
    opencv
    pcre
    x265
    jasper

    qtbase
    qtxmlpatterns
    qtsvg
    qtwebengine
<<<<<<< HEAD
    qtnetworkauth
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    akonadi-contacts
    kcalendarcore
    kconfigwidgets
    kcoreaddons
    kfilemetadata
    knotifications
    knotifyconfig
    ktextwidgets
    kwidgetsaddons
    kxmlgui

    breeze-icons
    marble
    oxygen
    threadweaver
<<<<<<< HEAD
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart
  ]);
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cmakeFlags = [
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
    "-DENABLE_MEDIAPLAYER=1"
    "-DENABLE_QWEBENGINE=on"
    "-DENABLE_APPSTYLES=on"
    "-DCMAKE_CXX_FLAGS=-I${libksane}/include/KF5" # fix `#include <ksane_version.h>`
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    qtWrapperArgs+=(--suffix DK_PLUGIN_PATH : ${placeholder "out"}/${qtbase.qtPluginPrefix}/${pname})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = "https://www.digikam.org";
    platforms = platforms.linux;
<<<<<<< HEAD
    mainProgram = "digikam";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
