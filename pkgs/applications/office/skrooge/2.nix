{ stdenv, fetchurl, cmake, ecm, makeQtWrapper, qtwebkit, qtscript, grantlee,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kdelibs4support, kactivities,
  knotifyconfig, krunner, libofx }:

stdenv.mkDerivation rec {
  name = "skrooge-${version}";
  version = "2.4.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.xz";
    sha256 = "132d022337140f841f51420536c31dfe07c90fa3a38878279026825f5d2526fe";
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
