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
, python3
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
, makeWrapper
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
    pyqt5
    sip_4
    owslib
    six
  ];
in mkDerivation rec {
  version = "3.24.0";
  pname = "qgis-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "sha256-EPF8sXAH7UAttLutxXGFovog3+XpXP0GXg2tu0mSU2s=";
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit py;
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

  nativeBuildInputs = [ makeWrapper cmake flex bison ninja ];

  # Force this pyqt_sip_dir variable to point to the sip dir in PyQt5
  #
  # TODO: Correct PyQt5 to provide the expected directory and fix
  # build to use PYQT5_SIP_DIR consistently.
  postPatch = ''
    substituteInPlace cmake/FindPyQt5.py \
      --replace 'sip_dir = cfg.default_sip_dir' 'sip_dir = "${py.pkgs.pyqt5}/${py.pkgs.python.sitePackages}/PyQt5/bindings"'
  '';

  cmakeFlags = [
    "-DCMAKE_SKIP_BUILD_RPATH=OFF"
    "-DWITH_3D=True"
    "-DWITH_PDAL=TRUE"
    "-DPYQT5_SIP_DIR=${py.pkgs.pyqt5}/${py.pkgs.python.sitePackages}/PyQt5/bindings"
    "-DQSCI_SIP_DIR=${py.pkgs.qscintilla-qt5}/${py.pkgs.python.sitePackages}/PyQt5/bindings"
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withGrass "-DGRASS_PREFIX7=${grass}/grass78";

  postFixup = lib.optionalString withGrass ''
    # grass has to be availble on the command line even though we baked in
    # the path at build time using GRASS_PREFIX
    wrapProgram $out/bin/qgis \
      --prefix PATH : ${lib.makeBinPath [ grass ]}
  '';

  meta = {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ lsix sikmir erictapen willcohen ];
  };
}
