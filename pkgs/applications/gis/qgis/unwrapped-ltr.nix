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
, qtlocation
, qtserialport
, qtxmlpatterns
, withGrass ? true
, grass
, withWebKit ? false
, qtwebkit
, pdal
, zstd
, makeWrapper
, wrapGAppsHook
, substituteAll
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
    pyqt-builder
    sip
    setuptools
    owslib
    six
  ];
in mkDerivation rec {
  version = "3.22.13";
  pname = "qgis-ltr-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-l9UaxPBTkKrTygise0nVBDrPX3aRRW62HtIYwrtYp3Q=";
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
    qtlocation
    qtserialport
    qtxmlpatterns
    qt3d
    pdal
    zstd
  ] ++ lib.optional withGrass grass
    ++ lib.optional withWebKit qtwebkit
    ++ pythonBuildInputs;

  nativeBuildInputs = [ makeWrapper wrapGAppsHook cmake flex bison ninja ];

  patches = [
    (substituteAll {
      src = ./set-pyqt-package-dirs.patch;
      pyQt5PackageDir = "${py.pkgs.pyqt5}/${py.pkgs.python.sitePackages}";
      qsciPackageDir = "${py.pkgs.qscintilla-qt5}/${py.pkgs.python.sitePackages}";
    })
  ];

  cmakeFlags = [
    "-DWITH_3D=True"
    "-DWITH_PDAL=TRUE"
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withGrass (let
        gmajor = lib.versions.major grass.version;
        gminor = lib.versions.minor grass.version;
      in "-DGRASS_PREFIX${gmajor}=${grass}/grass${gmajor}${gminor}"
    );

  dontWrapGApps = true; # wrapper params passed below

  postFixup = lib.optionalString withGrass ''
    # grass has to be availble on the command line even though we baked in
    # the path at build time using GRASS_PREFIX.
    # using wrapGAppsHook also prevents file dialogs from crashing the program
    # on non-NixOS
    wrapProgram $out/bin/qgis \
      "''${gappsWrapperArgs[@]}" \
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
