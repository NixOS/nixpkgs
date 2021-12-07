{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, ninja
, flex
, bison
, proj
, geos
, xlibsWrapper
, sqlite
, gsl
, qwt
, fcgi
, python3Packages
, libspatialindex
, libspatialite
, postgresql
, txt2tags
, openssl
, libzip
, hdf5
, netcdf
, exiv2
, protobuf
, qtbase
, qtsensors
, qca-qt5
, qtkeychain
, qt3d
, qscintilla
, qtserialport
, qtxmlpatterns
, withGrass ? true
, grass
, withWebKit ? true
, qtwebkit
, pdal
, zstd
}:

let

  pythonBuildInputs = with python3Packages; [
    qscintilla-qt5
    gdal
    jinja2
    numpy
    psycopg2
    chardet
    python-dateutil
    pyyaml
    pytz
    requests
    urllib3
    pygments
    pyqt5_with_qtlocation
    sip_4
    owslib
    six
  ];
in mkDerivation rec {
  version = "3.22.1";
  pname = "qgis-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256:0hpbbv84lh1m7vrxv8d8x5kxgxcf0dydsvr3r2brgv3b40lpavd4";
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit python3Packages;
  };

  buildInputs = [
    openssl
    proj
    geos
    xlibsWrapper
    sqlite
    gsl
    qwt
    exiv2
    protobuf
    fcgi
    libspatialindex
    libspatialite
    postgresql
    txt2tags
    libzip
    hdf5
    netcdf
    qtbase
    qtsensors
    qca-qt5
    qtkeychain
    qscintilla
    qtserialport
    qtxmlpatterns
    qt3d
    pdal
    zstd
  ] ++ lib.optional withGrass grass
    ++ lib.optional withWebKit qtwebkit
    ++ pythonBuildInputs;

  nativeBuildInputs = [ cmake flex bison ninja ];

  # Force this pyqt_sip_dir variable to point to the sip dir in PyQt5
  #
  # TODO: Correct PyQt5 to provide the expected directory and fix
  # build to use PYQT5_SIP_DIR consistently.
  postPatch = ''
    substituteInPlace cmake/FindPyQt5.py \
      --replace 'sip_dir = cfg.default_sip_dir' 'sip_dir = "${python3Packages.pyqt5_with_qtlocation}/${python3Packages.python.sitePackages}/PyQt5/bindings"'
  '';

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DWITH_3D=True"
    "-DWITH_PDAL=TRUE"
    "-DPYQT5_SIP_DIR=${python3Packages.pyqt5_with_qtlocation}/${python3Packages.python.sitePackages}/PyQt5/bindings"
    "-DQSCI_SIP_DIR=${python3Packages.qscintilla-qt5}/share/sip/PyQt5"
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withGrass "-DGRASS_PREFIX7=${grass}/grass78";

  meta = {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ lsix sikmir erictapen ];
  };
}
