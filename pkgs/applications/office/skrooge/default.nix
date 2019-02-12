{ mkDerivation, lib, fetchurl,
  cmake, extra-cmake-modules, qtwebkit, qtwebengine, qtscript, grantlee,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kactivities, karchive,
  kguiaddons, knotifyconfig, krunner, kwindowsystem, libofx, shared-mime-info
}:

mkDerivation rec {
  name = "skrooge-${version}";
  version = "2.17.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.xz";
    sha256 = "0v83bcabchsz5fs0iv5i75ps01sga48hq4cx29dajcq3kf9xgwhr";
  };

  nativeBuildInputs = [
    cmake extra-cmake-modules kdoctools shared-mime-info
  ];

  buildInputs = [
    qtwebkit qtwebengine qtscript grantlee kxmlgui kwallet kparts
    kjobwidgets kdesignerplugin kiconthemes knewstuff sqlcipher qca-qt5
    kactivities karchive kguiaddons knotifyconfig krunner kwindowsystem libofx
  ];

  # SKG_DESIGNER must be used to generate the needed library for QtDesigner.
  # This is needed ONLY for developers. So NOT NEEDED for end user.
  # Source: https://forum.kde.org/viewtopic.php?f=210&t=143375#p393675
  cmakeFlags = [
    "-DSKG_DESIGNER=OFF"
    "-DSKG_WEBENGINE=ON"
  ];

  meta = with lib; {
    description = "A personal finances manager, powered by KDE";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ joko ];
    homepage = https://skrooge.org/;
  };
}
