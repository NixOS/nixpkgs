{ stdenv, fetchhg
, qmake, qttools
, qtbase, qtsvg, qtxmlpatterns
, poppler_utils
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "valentina";
  version = "0.6.1";

  src = fetchhg {
    url = "https://bitbucket.org/dismine/valentina";
    rev = "v${version}";
    sha256 = "0dxk2av7xbsd233sr9wa1hamzb7pp8yx6p5b43rsnvnzchkqf423";
  };

  postPatch = ''
    substituteInPlace common.pri \
      --replace '$$[QT_INSTALL_HEADERS]/QtXmlPatterns' '${getDev qtxmlpatterns}/include/QtXmlPatterns' \
      --replace '$$[QT_INSTALL_HEADERS]/QtSvg' '${getDev qtsvg}/include/QtSvg' \
      --replace '$$[QT_INSTALL_HEADERS]/' '${getDev qtbase}/include/' \
      --replace '$$[QT_INSTALL_HEADERS]' '${getDev qtbase}'
    substituteInPlace src/app/tape/tape.pro \
      --replace '$$[QT_INSTALL_BINS]/rcc' '${getDev qtbase}/bin/rcc'
    substituteInPlace src/app/translations.pri \
      --replace '$$[QT_INSTALL_BINS]/$$LRELEASE' '${getDev qttools}/bin/lrelease'
    substituteInPlace src/app/valentina/mainwindowsnogui.cpp \
      --replace 'define PDFTOPS "pdftops"' 'define PDFTOPS "${getBin poppler_utils}/bin/pdftops"'
    substituteInPlace src/app/valentina/dialogs/dialogsavelayout.h \
      --replace 'define PDFTOPS "pdftops"' 'define PDFTOPS "${getBin poppler_utils}/bin/pdftops"'
  '';

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase qtsvg qtxmlpatterns poppler_utils ];

  configurePhase = ''
    qmake PREFIX=/ Valentina.pro -r "CONFIG += noTests noRunPath no_ccache noDebugSymbols"
  '';

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  postInstall = ''
    mv $out/usr/share $out/
    rmdir $out/usr

    mkdir -p $out/share/man/man1
    gzip -9c dist/debian/valentina.1 > $out/share/man/man1/valentina.1.gz
    gzip -9c dist/debian/tape.1 > $out/share/man/man1/tape.1.gz

    mkdir -p $out/share/mime/packages
    cp dist/debian/valentina.sharedmimeinfo $out/share/mime/packages/valentina.xml
  '';

  enableParallelBuilding = true;

  meta = {
    description = "An open source sewing pattern drafting software";
    homepage = https://valentinaproject.bitbucket.io/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ jfrankenau ];
  };
}
