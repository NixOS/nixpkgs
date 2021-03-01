{ boost
, fetchFromGitHub
, libGLU
, mkDerivationWith
, muparser
, pkg-config
, qtbase
, qmake
, qtscript
, qtsvg
, qtxmlpatterns
, qttools
, lib, stdenv
}:

mkDerivationWith stdenv.mkDerivation rec {
  pname = "qcad";
  version = "3.25.2.0";

  src = fetchFromGitHub {
    owner = "qcad";
    repo = "qcad";
    rev = "v${version}";
    sha256 = "1lz6q9n2p0l7k8rwqsdj6av9p3426423g5avc4y6s7nbk36280mz";
  };

  patches = [
    ./application-dir.patch
  ];

  postPatch = ''
    if ! [ -d src/3rdparty/qt-labs-qtscriptgenerator-${qtbase.version} ]; then
      mkdir src/3rdparty/qt-labs-qtscriptgenerator-${qtbase.version}
      cp \
        src/3rdparty/qt-labs-qtscriptgenerator-5.14.0/qt-labs-qtscriptgenerator-5.14.0.pro \
        src/3rdparty/qt-labs-qtscriptgenerator-${qtbase.version}/qt-labs-qtscriptgenerator-${qtbase.version}.pro
    fi
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

    # workaround to fix the library browser:
    rm -r $out/lib/plugins/sqldrivers
    ln -s -t $out/lib/plugins ${qtbase}/${qtbase.qtPluginPrefix}/sqldrivers

    install -Dm644 scripts/qcad_icon.svg $out/share/icons/hicolor/scalable/apps/qcad.svg

    runHook postInstall
    '';

  buildInputs = [
    boost
    muparser
    libGLU
    qtbase
    qtscript
    qtsvg
    qtxmlpatterns
  ];

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "2D CAD package based on Qt";
    homepage = "https://qcad.org";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yvesf ];
    platforms = qtbase.meta.platforms;
  };
}
