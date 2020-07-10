{ boost
, fetchFromGitHub
, mkDerivationWith
, muparser
, pkgconfig
, qmake
, qt5
, stdenv
, libGLU
}:

mkDerivationWith stdenv.mkDerivation rec {
  pname = "qcad";
  version = "3.24.3.10";

  src = fetchFromGitHub {
    owner = "qcad";
    repo = "qcad";
    rev = "v${version}";
    sha256 = "0izyn4y1ffq1mgxs5dymkrqih6n6v9ifrcpyk1z2vyhbm5xx4qsa";
  };

  patches = [
    ./application-dir.patch
  ];

  postPatch = ''
    mkdir src/3rdparty/qt-labs-qtscriptgenerator-${qt5.qtbase.version}
    cp \
      src/3rdparty/qt-labs-qtscriptgenerator-5.12.3/qt-labs-qtscriptgenerator-5.12.3.pro \
      src/3rdparty/qt-labs-qtscriptgenerator-${qt5.qtbase.version}/qt-labs-qtscriptgenerator-${qt5.qtbase.version}.pro
  '';

  qmakeFlags = [
    "MUPARSER_DIR=${muparser}"
    "INSTALLROOT=$(out)"
    "BOOST_DIR=${boost.dev}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm555 -t $out/bin release/qcad-bin
    install -Dm555 -t $out/lib release/libspatialindexnavel.so
    install -Dm555 -t $out/lib release/libqcadcore.so
    install -Dm555 -t $out/lib release/libqcadentity.so
    install -Dm555 -t $out/lib release/libqcadgrid.so
    install -Dm555 -t $out/lib release/libqcadsnap.so
    install -Dm555 -t $out/lib release/libqcadoperations.so
    install -Dm555 -t $out/lib release/libqcadstemmer.so
    install -Dm555 -t $out/lib release/libqcadspatialindex.so
    install -Dm555 -t $out/lib release/libqcadgui.so
    install -Dm555 -t $out/lib release/libqcadecmaapi.so

    install -Dm444 -t $out/share/applications qcad.desktop
    install -Dm644 -t $out/share/pixmaps      scripts/qcad_icon.png

    cp -r scripts $out/lib
    cp -r plugins $out/lib/plugins
    cp -r patterns $out/lib/patterns

    install -Dm644 scripts/qcad_icon.svg $out/share/icons/hicolor/scalable/apps/qcad.svg

    runHook postInstall
    '';

  buildInputs = [
    boost
    muparser
    libGLU
    qt5.qtbase
    qt5.qtscript
    qt5.qtsvg
    qt5.qtxmlpatterns
  ];

  nativeBuildInputs = [
    pkgconfig
    qt5.qmake
    qt5.qttools
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "2D CAD package based on Qt";
    homepage = "https://qcad.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yvesf ];
    platforms = qt5.qtbase.meta.platforms;
  };
}
