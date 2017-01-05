{ stdenv, fetchurl, cmake, ecm, makeQtWrapper, qtwebkit, qtscript, grantlee,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kdelibs4support, kactivities,
  knotifyconfig, krunner, libofx }:

stdenv.mkDerivation rec {
  name = "skrooge-${version}";
  version = "2.6.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.xz";
    sha256 = "13sd669rx66fpk9pm72nr2y69k2h4mcs4b904i9xm41i0fiy6szp";
  };

  nativeBuildInputs = [ cmake ecm makeQtWrapper ];

  buildInputs = [ qtwebkit qtscript grantlee kxmlgui kwallet kparts kdoctools
    kjobwidgets kdesignerplugin kiconthemes knewstuff sqlcipher qca-qt5
    kdelibs4support kactivities knotifyconfig krunner libofx
  ];

  enableParallelBuilding = true;

  postInstall = ''
    wrapQtProgram "$out/bin/skrooge"
    wrapQtProgram "$out/bin/skroogeconvert"
  '';

  meta = with stdenv.lib; {
    description = "A personal finances manager, powered by KDE";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ joko ];
    homepage = https://skrooge.org/;
  };
}
