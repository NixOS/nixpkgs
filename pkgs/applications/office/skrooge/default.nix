{ mkDerivation, lib, fetchurl,
  cmake, extra-cmake-modules, qtwebkit, qtscript, grantlee,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kactivities, karchive,
  kguiaddons, knotifyconfig, krunner, kwindowsystem, libofx, shared_mime_info
}:

mkDerivation rec {
  name = "skrooge-${version}";
  version = "2.9.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.xz";
    sha256 = "1dbvdrkdpgv39v8h7k3mri0nzlslfyd5kk410czj0jdn4qq400md";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules shared_mime_info ];

  buildInputs = [ qtwebkit qtscript grantlee kxmlgui kwallet kparts kdoctools
    kjobwidgets kdesignerplugin kiconthemes knewstuff sqlcipher qca-qt5
    kactivities karchive kguiaddons knotifyconfig krunner kwindowsystem libofx
  ];

  meta = with lib; {
    description = "A personal finances manager, powered by KDE";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ joko ];
    homepage = https://skrooge.org/;
  };
}
