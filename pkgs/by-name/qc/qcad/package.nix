{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  qt5,
  boost,
  libGLU,
  muparser,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qcad";
  version = "3.32.6.0";

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-src";
    owner = "qcad";
    repo = "qcad";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7PckPPD7CWd+IQWTLhr5+vizIjPpRdva2yDOyC6t0Uc=";
  };

  patches = [
    # Patch directory lookup, remove __DATE__ and executable name
    ./application-dir.patch
  ];

  postPatch = ''
    if ! [ -d src/3rdparty/qt-labs-qtscriptgenerator-${qt5.qtbase.version} ]; then
      mkdir src/3rdparty/qt-labs-qtscriptgenerator-${qt5.qtbase.version}
      cp \
        src/3rdparty/qt-labs-qtscriptgenerator-5.14.0/qt-labs-qtscriptgenerator-5.14.0.pro \
        src/3rdparty/qt-labs-qtscriptgenerator-${qt5.qtbase.version}/qt-labs-qtscriptgenerator-${qt5.qtbase.version}.pro
    fi
  '';

  nativeBuildInputs = [
    installShellFiles
    pkg-config
    qt5.qmake
    qt5.qttools
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    boost
    libGLU
    muparser
    qt5.qtbase
    qt5.qtscript
    qt5.qtsvg
    qt5.qtxmlpatterns
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    qt5.qtmacextras
  ];

  qmakeFlags = [
    "MUPARSER_DIR=${muparser}"
    "INSTALLROOT=$(out)"
    "BOOST_DIR=${boost.dev}"
    "QMAKE_CXXFLAGS=-std=c++14"
  ];

  qtWrapperArgs =
    lib.optionals stdenv.hostPlatform.isLinux [
      "--prefix LD_LIBRARY_PATH : ${placeholder "out"}/lib"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      "--prefix DYLD_LIBRARY_PATH : ${placeholder "out"}/lib"
    ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -Dm555 release/qcad-bin $out/bin/qcad
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    install -Dm555 release/QCAD.app/Contents/MacOS/QCAD $out/bin/qcad
    mkdir -p $out/lib
  ''
  + ''
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
    install -Dm644 scripts/qcad_icon.png $out/share/icons/hicolor/256x256/apps/org.qcad.QCAD.png
    cp -r scripts $out/lib
    cp -r plugins $out/lib/plugins
    cp -r patterns $out/lib/patterns
    cp -r fonts $out/lib/fonts
    cp -r libraries $out/lib/libraries
    cp -r linetypes $out/lib/linetypes
    cp -r ts $out/lib/ts

    # workaround to fix the library browser:
    rm -r $out/lib/plugins/sqldrivers
    ln -s -t $out/lib/plugins ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/sqldrivers

    rm -r $out/lib/plugins/printsupport
    ln -s -t $out/lib/plugins ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/printsupport

    rm -r $out/lib/plugins/imageformats
    ln -s -t $out/lib/plugins ${qt5.qtbase}/${qt5.qtbase.qtPluginPrefix}/imageformats

    install -Dm644 scripts/qcad_icon.svg $out/share/icons/hicolor/scalable/apps/org.qcad.QCAD.svg

    installManPage qcad.1

    runHook postInstall
  '';

  meta = {
    description = "2D CAD package based on Qt";
    homepage = "https://qcad.org";
    license = lib.licenses.gpl3Only;
    mainProgram = "qcad";
    maintainers = with lib.maintainers; [ yvesf ];
    platforms = qt5.qtbase.meta.platforms;
  };
})
