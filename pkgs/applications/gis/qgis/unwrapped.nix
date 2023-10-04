{ lib
, fetchFromGitHub
, fetchpatch
, makeWrapper
, mkDerivation
, substituteAll
, wrapGAppsHook
, wrapQtAppsHook

, withGrass ? true
, withWebKit ? false

, bison
, cmake
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
, zstd
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      pyqt5 = super.pyqt5.override {
        withLocation = true;
      };
    };
  };

  pythonBuildInputs = with py.pkgs; [
    chardet
    gdal
    jinja2
    numpy
    owslib
    psycopg2
    pygments
    pyqt-builder
    pyqt5
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
  version = "3.32.3";
  pname = "qgis-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-ge5ne22sDLKbrJk2vYQxpu3iRXSoOk9924c/RdtD3Nc=";
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit py;
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
    wrapQtAppsHook

    cmake
    flex
    bison
    ninja
  ];

  buildInputs = [
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
    (fetchpatch {
      name = "exiv2-0.28.patch";
      url = "https://github.com/qgis/QGIS/commit/32f5418fc4f7bb2ee986dee1824ff2989c113a94.patch";
      hash = "sha256-zWyf+kLro4ZyUJLX/nDjY0nLneTaI1DxHvRsvwoWq14=";
    })
  ];

  # Add path to Qt platform plugins
  # (offscreen is needed by "${APIS_SRC_DIR}/generate_console_pap.py")
  preBuild = ''
    export QT_QPA_PLATFORM_PLUGIN_PATH=${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforms
  '';

  cmakeFlags = [
    "-DWITH_3D=True"
    "-DWITH_PDAL=TRUE"
    "-DENABLE_TESTS=False"
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withGrass (let
        gmajor = lib.versions.major grass.version;
        gminor = lib.versions.minor grass.version;
      in "-DGRASS_PREFIX${gmajor}=${grass}/grass${gmajor}${gminor}"
    );

  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM_PLUGIN_PATH ${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforms"
  ];

  dontWrapGApps = true; # wrapper params passed below

  postFixup = lib.optionalString withGrass ''
    # GRASS has to be availble on the command line even though we baked in
    # the path at build time using GRASS_PREFIX.
    # Using wrapGAppsHook also prevents file dialogs from crashing the program
    # on non-NixOS.
    wrapProgram $out/bin/qgis \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ grass ]}
  '';

  meta = with lib; {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ lsix ];
    platforms = with platforms; linux;
  };
}
