{ stdenv, fetchurl, cmake, ecm, makeQtWrapper, qtwebkit, qtscript, grantlee,
  kxmlgui, kwallet, kparts, kdoctools, kjobwidgets, kdesignerplugin,
  kiconthemes, knewstuff, sqlcipher, qca-qt5, kdelibs4support, kactivities,
  knotifyconfig, krunner, libofx }:

stdenv.mkDerivation rec {
  name = "skrooge-${version}";
  version = "2.7.0";

  src = fetchurl {
    url = "http://download.kde.org/stable/skrooge/${name}.tar.xz";
    sha256 = "1xrh9nal122rzlv4m0x8qah6zpqb6891al3351piarpk2xgjgj4x";
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
