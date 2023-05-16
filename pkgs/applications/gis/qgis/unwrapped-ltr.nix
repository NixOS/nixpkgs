{ lib
<<<<<<< HEAD
, fetchFromGitHub
, makeWrapper
, mkDerivation
, substituteAll
, wrapGAppsHook

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
, qtsensors
, qtserialport
, qtwebkit
, qtxmlpatterns
, qwt
, sqlite
, txt2tags
, zstd
=======
, mkDerivation
, fetchFromGitHub
, cmake
, ninja
, flex
, bison
, proj
, geos
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
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
  version = "3.28.10";
=======
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
  version = "3.28.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "qgis-ltr-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
<<<<<<< HEAD
    hash = "sha256-5TGcXYfOJonpqecV59dhFcl4rNXbBSofdoTz5o5FFcc=";
=======
    hash = "sha256-3fQB0oCIZSVEVMZzmeyvw8/Ew+JjzAFnTIsnsklAayI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit py;
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook

    bison
    cmake
    flex
    ninja
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  buildInputs = [
    openssl
    proj
    geos
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

<<<<<<< HEAD
  patches = [
    (substituteAll {
      src = ./set-pyqt-package-dirs-ltr.patch;
=======
  nativeBuildInputs = [ makeWrapper wrapGAppsHook cmake flex bison ninja ];

  patches = [
    (substituteAll {
      src = ./set-pyqt-package-dirs.patch;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      pyQt5PackageDir = "${py.pkgs.pyqt5}/${py.pkgs.python.sitePackages}";
      qsciPackageDir = "${py.pkgs.qscintilla-qt5}/${py.pkgs.python.sitePackages}";
    })
  ];

  cmakeFlags = [
    "-DWITH_3D=True"
    "-DWITH_PDAL=TRUE"
<<<<<<< HEAD
    "-DENABLE_TESTS=False"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optional (!withWebKit) "-DWITH_QTWEBKIT=OFF"
    ++ lib.optional withGrass (let
        gmajor = lib.versions.major grass.version;
        gminor = lib.versions.minor grass.version;
      in "-DGRASS_PREFIX${gmajor}=${grass}/grass${gmajor}${gminor}"
    );

  dontWrapGApps = true; # wrapper params passed below

  postFixup = lib.optionalString withGrass ''
<<<<<<< HEAD
    # GRASS has to be availble on the command line even though we baked in
    # the path at build time using GRASS_PREFIX.
    # Using wrapGAppsHook also prevents file dialogs from crashing the program
    # on non-NixOS.
=======
    # grass has to be availble on the command line even though we baked in
    # the path at build time using GRASS_PREFIX.
    # using wrapGAppsHook also prevents file dialogs from crashing the program
    # on non-NixOS
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    wrapProgram $out/bin/qgis \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ grass ]}
  '';

<<<<<<< HEAD
  meta = with lib; {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ lsix ];
    platforms = with platforms; linux;
=======
  meta = {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ lsix sikmir willcohen ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
