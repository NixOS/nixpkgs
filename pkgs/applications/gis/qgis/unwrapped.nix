{ lib
, fetchFromGitHub
, makeWrapper
, mkDerivation
, substituteAll
, wrapGAppsHook3
, wrapQtAppsHook

, withGrass
, withServer
, withWebKit

, bison
, cmake
, draco
, exiv2
, fcgi
, flex
, geos
, grass
, gsl
, hdf5
, libspatialindex
, libspatialite
, libzip
, netcdf
, ninja
, openssl
, pdal
, perl
, postgresql
, proj
, protobuf
, python3
, qca-qt5
, qscintilla
, qt3d
, qtbase
, qtkeychain
, qtlocation
, qtmultimedia
, qtsensors
, qtserialport
, qtwebkit
, qtxmlpatterns
, qwt
, sqlite
, txt2tags
, xfontsel
, xorg
, xvfb-run
, zstd
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {
      pyqt5 = super.pyqt5.override {
        withLocation = true;
        withSerialPort = true;
      };
    };
  };

  pythonBuildInputs = with py.pkgs; [
    # FIXME: remove not needed packages
    # See: https://github.com/qgis/QGIS/blob/master/.docker/qgis3-qt5-build-deps.dockerfile
    chardet
    gdal
    jinja2
    numpy
    owslib
    psycopg2
    pygments
    pyqt5
    pyqt-builder
    python-dateutil
    pytz
    pyyaml
    qscintilla-qt5
    requests
    setuptools
    sip
    six
    urllib3
  ];
in mkDerivation rec {
  version = "3.40.1";
  pname = "qgis-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-C86RwyeIZrflC5F2VQCw1LwF9VM4/OBEsLbGPiWKeco=";
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit py;
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook3
    wrapQtAppsHook

    bison
    cmake
    flex
    ninja
  ];

  buildInputs = [
    draco
    exiv2
    fcgi
    geos
    gsl
    hdf5
    libspatialindex
    libspatialite
    libzip
    netcdf
    openssl
    pdal
    postgresql
    proj
    protobuf
    qca-qt5
    qscintilla
    qt3d
    qtbase
    qtkeychain
    qtlocation
    qtmultimedia
    qtsensors
    qtserialport
    qtxmlpatterns
    qwt
    sqlite
    txt2tags
    zstd
  ] ++ lib.optional withGrass grass
    ++ lib.optional withWebKit qtwebkit
    ++ pythonBuildInputs;

  patches = [
    (substituteAll {
      src = ./set-pyqt-package-dirs.patch;
      pyQt5PackageDir = "${py.pkgs.pyqt5}/${py.pkgs.python.sitePackages}";
      qsciPackageDir = "${py.pkgs.qscintilla-qt5}/${py.pkgs.python.sitePackages}";
    })
  ];

  # Add path to Qt platform plugins
  # (offscreen is needed by "${APIS_SRC_DIR}/generate_console_pap.py")
  env.QT_QPA_PLATFORM_PLUGIN_PATH="${qtbase}/${qtbase.qtPluginPrefix}/platforms";

  cmakeFlags = [
    "-DWITH_3D=True"
    "-DWITH_PDAL=True"
    "-DENABLE_TESTS=True"
    "-DHAS_KDE_QT5_PDF_TRANSFORM_FIX=True"
    "-DHAS_KDE_QT5_SMALL_CAPS_FIX=True"
    "-DHAS_KDE_QT5_FONT_STRETCH_FIX=True"
    "-DQT_PLUGINS_DIR=${qtbase}/${qtbase.qtPluginPrefix}"
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withServer [
    "-DWITH_SERVER=True"
    "-DQGIS_CGIBIN_SUBDIR=${placeholder "out"}/lib/cgi-bin"
  ] ++ lib.optional withGrass (let
        gmajor = lib.versions.major grass.version;
        gminor = lib.versions.minor grass.version;
      in "-DGRASS_PREFIX${gmajor}=${grass}/grass${gmajor}${gminor}"
    );

  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase}/${qtbase.qtPluginPrefix}/platforms"
  ];

  dontWrapGApps = true; # wrapper params passed below

  postFixup = lib.optionalString withGrass ''
    # GRASS has to be availble on the command line even though we baked in
    # the path at build time using GRASS_PREFIX.
    # Using wrapGAppsHook also prevents file dialogs from crashing the program
    # on non-NixOS.
    for program in $out/bin/*; do
      wrapProgram $program \
        "''${gappsWrapperArgs[@]}" \
        --prefix PATH : ${lib.makeBinPath [ grass ]}
    done
  '';


  doCheck = true;

  # List of build dependencies:
  # https://github.com/qgis/QGIS/blob/master/.docker/qgis3-qt5-build-deps.dockerfile
  nativeCheckInputs = [
    wrapQtAppsHook
    python3.pkgs.nose2
    python3.pkgs.mock
    (perl.withPackages(p: [ p.YAMLTiny ]))  # required for tests/code_layout/sipify
    qtbase
    xfontsel
    xorg.xauth
    xvfb-run
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${qtbase}/${qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH=${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforms
    export QGIS_PREFIX_PATH="output"
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -a -n 1 -s '-screen 0 1280x1024x24 -dpi 96' ctest --label-exclude POSTGRES --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'
    runHook postCheck
  '';

  # List of excluded tests:
  # https://github.com/qgis/QGIS/blob/master/.ci/test_blocklist_qt5.txt
  # List of flaky tests:
  # https://github.com/qgis/QGIS/blob/master/.ci/test_flaky.txt
  disabledTests = [

];

  meta = with lib; {
    description = "Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ lsix ];
    platforms = with platforms; linux;
  };
}
