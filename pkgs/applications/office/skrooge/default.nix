{ mkDerivation, lib, fetchurl,
  cmake, extra-cmake-modules, qtwebengine, qtscript, grantlee,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kactivities, karchive,
  kguiaddons, knotifyconfig, krunner, kwindowsystem, libofx, shared-mime-info
}:

mkDerivation rec {
  pname = "skrooge";
  version = "2.20.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${pname}-${version}.tar.xz";
    sha256 = "0rakfngp7j2x7h1isg6lbc5kva6k1kg99dz0zl43dc28s15can1w";
  };

  nativeBuildInputs = [
    cmake extra-cmake-modules kdoctools shared-mime-info
  ];

  buildInputs = [
    qtwebengine qtscript grantlee kxmlgui kwallet kparts
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
    broken = true;
  };
}
