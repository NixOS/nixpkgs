{ mkDerivation, lib, fetchFromGitHub, cmake, ninja, flex, bison, proj, geos
, xlibsWrapper, sqlite, gsl, qwt, fcgi, python3Packages, libspatialindex
, libspatialite, postgresql, txt2tags, openssl, libzip, hdf5, netcdf, exiv2
, protobuf, qtbase, qtsensors, qca-qt5, qtkeychain, qscintilla, qtserialport
, qtxmlpatterns, withGrass ? true, grass, withWebKit ? true, qtwebkit }:
with lib;
let
  pythonBuildInputs = with python3Packages; [
    qscintilla-qt5
    gdal
    jinja2
    numpy
    psycopg2
    chardet
    dateutil
    pyyaml
    pytz
    requests
    urllib3
    pygments
    pyqt5
    sip_4
    owslib
    six
  ];
in mkDerivation rec {
  version = "3.16.6";
  pname = "qgis";
  name = "${pname}-unwrapped-${version}";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "1vnz5kiyjircmhn4vq3fa5j2kvkxpwcsry7jc6nxl0w0dqx1zay1";
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
      --replace 'sip_dir = cfg.default_sip_dir' 'sip_dir = "${python3Packages.pyqt5}/share/sip/PyQt5"'
  '';

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/share/sip/PyQt5"
    "-DQSCI_SIP_DIR=${python3Packages.qscintilla-qt5}/share/sip/PyQt5"
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withGrass "-DGRASS_PREFIX7=${grass}/${grass.name}";

  meta = {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ lsix sikmir ];
  };
}
