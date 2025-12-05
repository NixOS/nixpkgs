{
  lib,
  fetchFromGitHub,
  makeWrapper,
  mkDerivation,
  replaceVars,
  wrapGAppsHook3,
  wrapQtAppsHook,

  withGrass,
  withServer,
  withWebKit,

  bison,
  cmake,
  draco,
  exiv2,
  fcgi,
  flex,
  geos,
  grass,
  gsl,
  hdf5,
  libspatialite,
  libzip,
  netcdf,
  ninja,
  openssl,
  pdal,
  libpq,
  proj,
  protobuf,
  python3,
  qca-qt5,
  qscintilla,
  qt3d,
  qtbase,
  qtkeychain,
  qtlocation,
  qtmultimedia,
  qtsensors,
  qtserialport,
  qtwebkit,
  qtxmlpatterns,
  qwt,
  sqlite,
  txt2tags,
  zstd,
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
in
mkDerivation rec {
  version = "3.44.5";
  pname = "qgis-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-VrI3pk7Qi0A9D7ONl18YeX9cFS6NfSU2Hvrzx8JIoXo=";
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
    libspatialite
    libzip
    netcdf
    openssl
    pdal
    libpq
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
  ]
  ++ lib.optional withGrass grass
  ++ lib.optional withWebKit qtwebkit
  ++ pythonBuildInputs;

  patches = [
    (replaceVars ./set-pyqt-package-dirs.patch {
      pyQt5PackageDir = "${py.pkgs.pyqt5}/${py.pkgs.python.sitePackages}";
      qsciPackageDir = "${py.pkgs.qscintilla-qt5}/${py.pkgs.python.sitePackages}";
    })
  ];

  # Add path to Qt platform plugins
  # (offscreen is needed by "${APIS_SRC_DIR}/generate_console_pap.py")
  env.QT_QPA_PLATFORM_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}/platforms";

  cmakeFlags = [
    "-DWITH_3D=True"
    "-DWITH_PDAL=True"
    "-DENABLE_TESTS=False"
    "-DQT_PLUGINS_DIR=${qtbase}/${qtbase.qtPluginPrefix}"

    # See https://github.com/libspatialindex/libspatialindex/issues/276
    "-DWITH_INTERNAL_SPATIALINDEX=True"
  ]
  ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
  ++ lib.optional withServer [
    "-DWITH_SERVER=True"
    "-DQGIS_CGIBIN_SUBDIR=${placeholder "out"}/lib/cgi-bin"
  ]
  ++ lib.optional withGrass (
    let
      gmajor = lib.versions.major grass.version;
      gminor = lib.versions.minor grass.version;
    in
    "-DGRASS_PREFIX${gmajor}=${grass}/grass${gmajor}${gminor}"
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

  # >9k objects, >3h build time on a normal build slot
  requiredSystemFeatures = [ "big-parallel" ];

  meta = with lib; {
    description = "Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ lsix ];
    teams = [ teams.geospatial ];
    platforms = with platforms; linux;
  };
}
