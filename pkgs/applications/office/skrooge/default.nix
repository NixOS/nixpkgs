{ mkDerivation, lib, fetchurl,
  cmake, extra-cmake-modules, qtwebengine, qtscript, grantlee, qtxmlpatterns,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kactivities, karchive,
  kguiaddons, knotifyconfig, krunner, kwindowsystem, libofx, shared-mime-info
}:

mkDerivation rec {
  pname = "skrooge";
  version = "2.31.0";

  src = fetchurl {
    url = "mirror://kde/stable/skrooge/skrooge-${version}.tar.xz";
    hash = "sha256-S90sUKJkUwgPAGlIuyN05a5DoehTFpFOnVLMF8Ac+HI=";
  };

  nativeBuildInputs = [
    cmake extra-cmake-modules kdoctools shared-mime-info
  ];

  buildInputs = [
    qtwebengine qtscript grantlee kxmlgui kwallet kparts qtxmlpatterns
    kjobwidgets kdesignerplugin kiconthemes knewstuff sqlcipher qca-qt5
    kactivities karchive kguiaddons knotifyconfig krunner kwindowsystem libofx
  ];

  # SKG_DESIGNER must be used to generate the needed library for QtDesigner.
  # This is needed ONLY for developers. So NOT NEEDED for end user.
  # Source: https://forum.kde.org/viewtopic.php?f=210&t=143375#p393675
  cmakeFlags = [
    "-DSKG_DESIGNER=OFF"
    "-DSKG_WEBENGINE=ON"
    "-DSKG_WEBKIT=OFF"
    "-DBUILD_TESTS=ON"
  ];

  meta = with lib; {
    description = "Personal finances manager, powered by KDE";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ joko ];
    homepage = "https://skrooge.org/";
  };
}
