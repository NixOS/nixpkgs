{
  stdenv,
  config,
  lib,
  fetchFromGitLab,
  cmake,
  ninja,
  doxygen,
  extra-cmake-modules,
  wrapGAppsHook3,

  # For `digitaglinktree`
  perl,
  sqlite,

  libsForQt5,

  bison,
  boost,
  eigen,
  exiv2,
  ffmpeg_4,
  flex,
  graphviz,
  imagemagick,
  lcms2,
  lensfun,
  libgphoto2,
  liblqr1,
  libusb1,
  libheif,
  libGL,
  libGLU,
  opencv,
  pcre,
  x265,
  jasper,

  bash,
  # For panorama and focus stacking
  enblend-enfuse,
  hugin,
  gnumake,

  cudaSupport ? config.cudaSupport,
  cudaPackages ? { },
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "digikam";
  version = "8.4.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "digikam";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GJYlxJkvFEXppVk0yC9ojszylfAGt3eBMAjNUu60XDY=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    doxygen
    extra-cmake-modules
    libsForQt5.kdoctools
    libsForQt5.wrapQtAppsHook
    wrapGAppsHook3
  ] ++ lib.optionals cudaSupport (with cudaPackages; [ cuda_nvcc ]);

  buildInputs =
    [
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
      libheif
      liblqr1
      libusb1
      libGL
      libGLU
      opencv
      pcre
      x265
      jasper
    ]
    ++ (with libsForQt5; [
      libkipi
      libksane

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
    ])
    ++ lib.optionals cudaSupport (with cudaPackages; [ cuda_cudart ]);

  postPatch = ''
    substituteInPlace \
      core/dplugins/bqm/custom/userscript/userscript.cpp \
      core/utilities/import/backend/cameracontroller.cpp \
      --replace-fail \"/bin/bash\" \"${lib.getExe bash}\"
  '';

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
    qtWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        gnumake
        hugin
        enblend-enfuse
      ]
    })
    qtWrapperArgs+=(--suffix DK_PLUGIN_PATH : ${placeholder "out"}/${libsForQt5.qtbase.qtPluginPrefix}/digikam)
    substituteInPlace $out/bin/digitaglinktree \
      --replace "/usr/bin/perl" "${perl}/bin/perl" \
      --replace "/usr/bin/sqlite3" "${sqlite}/bin/sqlite3"
  '';

  meta = {
    description = "Photo management application";
    homepage = "https://www.digikam.org/";
    changelog = "${finalAttrs.src.meta.homepage}-/blob/master/project/NEWS.${finalAttrs.version}";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "digikam";
  };
})
