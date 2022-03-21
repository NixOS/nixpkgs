{ lib
, stdenv
, mkDerivation
, fetchFromGitHub
, installShellFiles
, pkg-config
, qmake
, qttools
, boost
, libGLU
, muparser
, qtbase
, qtscript
, qtsvg
, qtxmlpatterns
, qtmacextras
}:

mkDerivation rec {
  pname = "qcad";
  version = "3.27.1.6";

  src = fetchFromGitHub {
    name = "qcad-${version}-src";
    owner = "qcad";
    repo = "qcad";
    rev = "v${version}";
    sha256 = "sha256-NnaCwbk8w0ZPnBz7xxs5LMFMUSnEERCSRBXpJL0u+s0=";
  };

  patches = [
    # Patch directory lookup, remove __DATE__ and executable name
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

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    qmake
    qttools
  ];

  buildInputs = [
    boost
    libGLU
    muparser
    qtbase
    qtscript
    qtsvg
    qtxmlpatterns
  ] ++ lib.optionals stdenv.isDarwin [
    qtmacextras
  ];

  qmakeFlags = [
    "MUPARSER_DIR=${muparser}"
    "INSTALLROOT=$(out)"
    "BOOST_DIR=${boost.dev}"
  ];

  qtWrapperArgs =
    lib.optionals stdenv.isLinux [ "--prefix LD_LIBRARY_PATH : ${placeholder "out"}/lib" ]
    ++
    lib.optionals stdenv.isDarwin [ "--prefix DYLD_LIBRARY_PATH : ${placeholder "out"}/lib" ];

  installPhase = ''
    runHook preInstall

  '' + lib.optionalString stdenv.isLinux ''
    install -Dm555 release/qcad-bin $out/bin/qcad
  '' + lib.optionalString stdenv.isDarwin ''
    install -Dm555 release/QCAD.app/Contents/MacOS/QCAD $out/bin/qcad
    mkdir -p $out/lib
  '' +
  ''
    install -Dm555 -t $out/lib release/libspatialindexnavel${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadcore${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadentity${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadgrid${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadsnap${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadoperations${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadstemmer${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadspatialindex${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadgui${stdenv.hostPlatform.extensions.sharedLibrary}
    install -Dm555 -t $out/lib release/libqcadecmaapi${stdenv.hostPlatform.extensions.sharedLibrary}

    install -Dm444 -t $out/share/applications qcad.desktop
    install -Dm644 -t $out/share/pixmaps      scripts/qcad_icon.png

    cp -r scripts $out/lib
    cp -r plugins $out/lib/plugins
    cp -r patterns $out/lib/patterns
    cp -r fonts $out/lib/fonts
    cp -r libraries $out/lib/libraries
    cp -r linetypes $out/lib/linetypes
    cp -r ts $out/lib/ts

    # workaround to fix the library browser:
    rm -r $out/lib/plugins/sqldrivers
    ln -s -t $out/lib/plugins ${qtbase}/${qtbase.qtPluginPrefix}/sqldrivers

    rm -r $out/lib/plugins/printsupport
    ln -s -t $out/lib/plugins ${qtbase}/${qtbase.qtPluginPrefix}/printsupport

    rm -r $out/lib/plugins/imageformats
    ln -s -t $out/lib/plugins ${qtbase}/${qtbase.qtPluginPrefix}/imageformats

    install -Dm644 scripts/qcad_icon.svg $out/share/icons/hicolor/scalable/apps/qcad.svg

    installManPage qcad.1

    runHook postInstall
  '';

  meta = with lib; {
    description = "2D CAD package based on Qt";
    homepage = "https://qcad.org";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ yvesf ];
    platforms = qtbase.meta.platforms;
  };
}
