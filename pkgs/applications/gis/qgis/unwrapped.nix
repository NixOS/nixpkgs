{ mkDerivation, lib, fetchFromGitHub, cmake, ninja, flex, bison, proj, geos, xlibsWrapper, sqlite, gsl
, qwt, fcgi, python3Packages, libspatialindex, libspatialite, postgresql
, txt2tags, openssl, libzip, hdf5, netcdf, exiv2
, qtbase, qtwebkit, qtsensors, qca-qt5, qtkeychain, qscintilla, qtserialport, qtxmlpatterns
, withGrass ? true, grass
}:
with lib;
let
  pythonBuildInputs = with python3Packages;
    [ qscintilla-qt5 gdal jinja2 numpy psycopg2
      chardet dateutil pyyaml pytz requests urllib3 pygments pyqt5 sip owslib six ];
in mkDerivation rec {
  version = "3.10.11";
  pname = "qgis";
  name = "${pname}-unwrapped-${version}";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "157hwi9sgnsf0csbfg4x3c7vh0zgf1hnqgn04lhg9xa1n8jjbv2q";
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit python3Packages;
  };

  buildInputs = [ openssl proj geos xlibsWrapper sqlite gsl qwt exiv2
    fcgi libspatialindex libspatialite postgresql txt2tags libzip hdf5 netcdf
    qtbase qtwebkit qtsensors qca-qt5 qtkeychain qscintilla qtserialport qtxmlpatterns] ++
    (lib.optional withGrass grass) ++ pythonBuildInputs;

  nativeBuildInputs = [ cmake flex bison ninja ];

  # Force this pyqt_sip_dir variable to point to the sip dir in PyQt5
  #
  # TODO: Correct PyQt5 to provide the expected directory and fix
  # build to use PYQT5_SIP_DIR consistently.
  postPatch = ''
     substituteInPlace cmake/FindPyQt5.py \
       --replace 'sip_dir = cfg.default_sip_dir' 'sip_dir = "${python3Packages.pyqt5}/share/sip/PyQt5"'
   '';

  cmakeFlags = [ "-DCMAKE_SKIP_BUILD_RPATH=OFF"
                 "-DPYQT5_SIP_DIR=${python3Packages.pyqt5}/share/sip/PyQt5"
                 "-DQSCI_SIP_DIR=${python3Packages.qscintilla-qt5}/share/sip/PyQt5" ] ++
                 lib.optional withGrass "-DGRASS_PREFIX7=${grass}/${grass.name}";

  meta = {
    description = "A Free and Open Source Geographic Information System";
    homepage = "http://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ lsix ];
    # Our 3.10 LTS cannot use a newer Qt (5.15) version because it requires qtwebkit
    # and our qtwebkit fails to build with 5.15. 01bcfd3579219d60e5d07df309a000f96b2b658b
    broken = true;
  };
}
