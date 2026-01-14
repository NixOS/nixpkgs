{
  lib,
  stdenv,
  fetchFromGitHub,
  lndir,
  makeWrapper,
  mkDerivation,
  replaceVars,
  wrapGAppsHook3,
  wrapQtAppsHook,

  withGrass,
  withServer,
  withWebKit,

  darwin,
  libtasn1,
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
  qtsvg,
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
    pyqt5-sip
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
  version = "3.44.6";
  pname = "qgis-unwrapped";
  outputs = [ "out" ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) "man";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-gC7luJpGSrKHRmgOetrLDE8zegbE/4QjM+aHaew5pGM=";
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
    lndir
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
    qtsvg
    qtxmlpatterns
    qwt
    sqlite
    txt2tags
    zstd
  ]
  ++ lib.optional withGrass grass
  ++ lib.optional withWebKit qtwebkit
  ++ lib.optional stdenv.hostPlatform.isDarwin libtasn1
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DQGIS_MACAPP_BUNDLE=0" # Don't copy Qt into bundle; we fix paths in postFixup
    "-DSQLITE3_INCLUDE_DIR=${sqlite.dev}/include" # FindSqlite3.cmake incorrectly assumes framework
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
  dontWrapQtApps = stdenv.hostPlatform.isDarwin;

  postFixup =
    lib.optionalString (withGrass && stdenv.hostPlatform.isLinux) ''
      # GRASS has to be available on the command line even though we baked in
      # the path at build time using GRASS_PREFIX.
      # Using wrapGAppsHook also prevents file dialogs from crashing the program
      # on non-NixOS.
      for program in $out/bin/*; do
        wrapProgram $program \
          "''${gappsWrapperArgs[@]}" \
          --prefix PATH : ${lib.makeBinPath [ grass ]}
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
            mkdir -p $out/Applications $out/bin
            mv $out/QGIS.app $out/Applications/
            ln -s $out/Applications/QGIS.app/Contents/MacOS/QGIS $out/bin/qgis

            SHORT_VERSION=$(echo "${version}" | cut -d. -f1,2)
            BUNDLE="$out/Applications/QGIS.app"
            FRAMEWORKS="$BUNDLE/Contents/Frameworks"

            fix_binary() {
              local f="$1"
              [[ -f "$f" ]] || return 0
              file "$f" | grep -q "Mach-O" || return 0

              install_name_tool \
                -change "@loader_path/../lib/libqscintilla2_qt5.dylib" "${qscintilla}/lib/libqscintilla2_qt5.dylib" \
                -change "@loader_path/../lib/libqt5keychain.dylib" "${qtkeychain}/lib/libqt5keychain.dylib" \
                -change "@loader_path/../lib/libqwt.dylib" "${qwt}/lib/libqwt.dylib" \
                -change "@loader_path/../../Frameworks/qca-qt5.framework/qca-qt5" "${qca-qt5}/lib/qca-qt5.framework/qca-qt5" \
                -change "@loader_path/../../../qca-qt5.framework/qca-qt5" "${qca-qt5}/lib/qca-qt5.framework/qca-qt5" \
                -change "@loader_path/../../../../MacOS/lib/libqscintilla2_qt5.dylib" "${qscintilla}/lib/libqscintilla2_qt5.dylib" \
                -change "@loader_path/../../../../MacOS/lib/libqt5keychain.dylib" "${qtkeychain}/lib/libqt5keychain.dylib" \
                -change "@loader_path/../../../../MacOS/lib/libqwt.dylib" "${qwt}/lib/libqwt.dylib" \
                -change "@executable_path/lib/libqwt.dylib" "${qwt}/lib/libqwt.dylib" \
                -change "@executable_path/lib/libqscintilla2_qt5.dylib" "${qscintilla}/lib/libqscintilla2_qt5.dylib" \
                -change "@executable_path/lib/libqt5keychain.dylib" "${qtkeychain}/lib/libqt5keychain.dylib" \
                -change "@executable_path/../Frameworks/qca-qt5.framework/qca-qt5" "${qca-qt5}/lib/qca-qt5.framework/qca-qt5" \
                -change "@loader_path/../../../qgis_core.framework/qgis_core" "$FRAMEWORKS/qgis_core.framework/Versions/$SHORT_VERSION/qgis_core" \
                -change "@loader_path/../../../qgis_gui.framework/qgis_gui" "$FRAMEWORKS/qgis_gui.framework/Versions/$SHORT_VERSION/qgis_gui" \
                -change "@loader_path/../../../qgis_analysis.framework/qgis_analysis" "$FRAMEWORKS/qgis_analysis.framework/Versions/$SHORT_VERSION/qgis_analysis" \
                -change "@loader_path/../../../qgis_3d.framework/qgis_3d" "$FRAMEWORKS/qgis_3d.framework/Versions/$SHORT_VERSION/qgis_3d" \
                -change "@loader_path/../../../qgis_native.framework/qgis_native" "$FRAMEWORKS/qgis_native.framework/Versions/$SHORT_VERSION/qgis_native" \
                "$f" 2>/dev/null || true
            }

            fix_binary "$BUNDLE/Contents/MacOS/QGIS"
            for lib in "$BUNDLE/Contents/MacOS/lib"/*.dylib; do fix_binary "$lib"; done
            for fw in qgis_core qgis_gui qgis_analysis qgis_3d qgis_native; do
              fix_binary "$FRAMEWORKS/$fw.framework/Versions/$SHORT_VERSION/$fw"
              [[ -f "$FRAMEWORKS/$fw.framework/$fw" && ! -L "$FRAMEWORKS/$fw.framework/$fw" ]] && \
                fix_binary "$FRAMEWORKS/$fw.framework/$fw"
            done
            for plugin in "$BUNDLE/Contents/PlugIns/qgis"/*.so; do fix_binary "$plugin"; done

            ${lib.optionalString withGrass ''
              fix_binary "$FRAMEWORKS/qgisgrass8.framework/Versions/$SHORT_VERSION/qgisgrass8"
              install_name_tool \
                -change "@loader_path/../../../qgisgrass8.framework/qgisgrass8" "$FRAMEWORKS/qgisgrass8.framework/Versions/$SHORT_VERSION/qgisgrass8" \
                "$BUNDLE/Contents/MacOS/QGIS" 2>/dev/null || true
              for lib in "$BUNDLE/Contents/MacOS/lib"/*.dylib; do
                install_name_tool \
                  -change "@loader_path/../../../qgisgrass8.framework/qgisgrass8" "$FRAMEWORKS/qgisgrass8.framework/Versions/$SHORT_VERSION/qgisgrass8" \
                  "$lib" 2>/dev/null || true
              done
            ''}

            ${lib.optionalString withServer ''
              fix_binary "$BUNDLE/Contents/MacOS/lib/libqgis_server.${version}.dylib"
            ''}

            # Merge Python packages (lndir handles namespace packages correctly)
            QGIS_PYTHON="$BUNDLE/Contents/Resources/python"
            for pkg in ${
              lib.concatMapStringsSep " " (p: "${p}/${py.pkgs.python.sitePackages}") (
                py.pkgs.requiredPythonModules pythonBuildInputs
              )
            }; do
              [[ -d "$pkg" ]] && lndir -silent "$pkg" "$QGIS_PYTHON"
            done
            # Remove broken symlinks
            find "$QGIS_PYTHON" -type l ! -exec test -e {} \; -delete

            # Create merged Qt plugins directory in the bundle (LSEnvironment is unreliable)
            mkdir -p "$BUNDLE/Contents/PlugIns"
            lndir -silent "${qtbase}/${qtbase.qtPluginPrefix}" "$BUNDLE/Contents/PlugIns"
            lndir -silent "${qtsvg.bin}/${qtbase.qtPluginPrefix}" "$BUNDLE/Contents/PlugIns"

            cat > "$BUNDLE/Contents/Resources/qt.conf" << 'EOF'
      [Paths]
      Plugins = PlugIns
      EOF
    '';

  # >9k objects, >3h build time on a normal build slot
  requiredSystemFeatures = [ "big-parallel" ];

  meta = {
    description = "Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
}
