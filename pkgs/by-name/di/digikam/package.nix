{ stdenv, config, lib, fetchpatch, fetchurl, cmake, doxygen, extra-cmake-modules, wrapGAppsHook

# For `digitaglinktree`
, perl, sqlite

, libsForQt5

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
, liblqr1
, libusb1
, libGL
, libGLU
, opencv
, pcre
, x265
, jasper

# For panorama and focus stacking
, enblend-enfuse
, hugin
, gnumake

, cudaSupport ? config.cudaSupport
, cudaPackages ? {}
}:

stdenv.mkDerivation rec {
  pname   = "digikam";
  version = "8.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${version}/digiKam-${version}.tar.xz";
    hash = "sha256-BQPANORF/0JPGKZxXAp6eb5KXgyCs+vEYaIc7DdFpbM=";
  };

  # Fix build against exiv2 0.28.1
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/graphics/digikam/-/commit/f5ea91a7f6c1926815ec68f3e0176d6c15b83051.patch";
      hash = "sha256-5g2NaKKNKVfgW3dTO/IP/H/nZ0YAIOmdPAumy3NEaNg=";
    })
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    extra-cmake-modules
    libsForQt5.kdoctools
    libsForQt5.wrapQtAppsHook
    wrapGAppsHook
  ] ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_nvcc
  ]);

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
    liblqr1
    libusb1
    libGL
    libGLU
    opencv
    pcre
    x265
    jasper
  ] ++ (with libsForQt5; [
    libkipi
    libksane
    libqtav

    qtbase
    qtxmlpatterns
    qtsvg
    qtwebengine
    qtnetworkauth

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
  ]) ++ lib.optionals cudaSupport (with cudaPackages; [
    cuda_cudart
  ]);

  cmakeFlags = [
    "-DENABLE_MYSQLSUPPORT=1"
    "-DENABLE_INTERNALMYSQL=1"
    "-DENABLE_MEDIAPLAYER=1"
    "-DENABLE_QWEBENGINE=on"
    "-DENABLE_APPSTYLES=on"
    "-DCMAKE_CXX_FLAGS=-I${libsForQt5.libksane}/include/KF5" # fix `#include <ksane_version.h>`
  ];

  dontWrapGApps = true;

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
    qtWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ gnumake hugin enblend-enfuse ]})
    qtWrapperArgs+=(--suffix DK_PLUGIN_PATH : ${placeholder "out"}/${libsForQt5.qtbase.qtPluginPrefix}/${pname})
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = with lib; {
    description = "Photo Management Program";
    license = licenses.gpl2;
    homepage = "https://www.digikam.org";
    maintainers = with maintainers; [ spacefault ];
    platforms = platforms.linux;
    mainProgram = "digikam";
  };
}
