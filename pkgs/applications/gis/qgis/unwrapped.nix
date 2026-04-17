{
  lib,
  stdenv,

  fetchFromGitHub,
  lndir,
  makeWrapper,
  replaceVars,
  wrapGAppsHook3,
  wrapQtAppsHook,

  withGrass,
  withServer,

  darwin,
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
  libtasn1,
  libspatialindex,
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
  qca,
  qscintilla,
  qt3d,
  qt5compat,
  qtbase,
  qtdeclarative,
  qtkeychain,
  qtlocation,
  qtmultimedia,
  qtsensors,
  qtserialport,
  qtsvg,
  qttools,
  qtwebengine,
  qwt,
  sqlite,
  txt2tags,
  zstd,
}:

let
  py = python3.override {
    self = py;
    packageOverrides = self: super: {
      pyqt6 = super.pyqt6.override {
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
    pyqt6
    pyqt-builder
    python-dateutil
    pytz
    pyyaml
    qscintilla-qt6
    requests
    setuptools
    sip
    six
    urllib3
  ];

in
stdenv.mkDerivation rec {
  pname = "qgis-unwrapped";
  version = "4.0.1";
  outputs = [ "out" ] ++ lib.optional (!stdenv.hostPlatform.isDarwin) "man";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-pH48EhH2kmlscFPYiLStGIqXrmO9zgpidtkWVf1K5Mo=";
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
    libpq
    libspatialindex
    libspatialite
    libzip
    netcdf
    openssl
    pdal
    proj
    protobuf
    qca
    qscintilla
    qt3d
    qt5compat
    qtbase
    qtdeclarative
    qtkeychain
    qtlocation
    qtmultimedia
    qtsensors
    qtserialport
    qttools
    qtwebengine
    qwt
    sqlite
    txt2tags
    zstd
  ]
  ++ lib.optional withGrass grass
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libtasn1
    qtsvg
  ]
  ++ pythonBuildInputs;

  patches = [
    (replaceVars ./set-pyqt6-package-dirs.patch {
      pyQt6PackageDir = "${py.pkgs.pyqt6}/${py.pkgs.python.sitePackages}";
      qsciPackageDir = "${py.pkgs.qscintilla-qt6}/${py.pkgs.python.sitePackages}";
    })
    (replaceVars ./spatialite-path.patch {
      spatialiteLib = "${libspatialite}/lib/mod_spatialite${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  # Add path to Qt platform plugins
  # (offscreen is needed by "${APIS_SRC_DIR}/generate_console_pap.py")
  env.QT_QPA_PLATFORM_PLUGIN_PATH = "${qtbase}/${qtbase.qtPluginPrefix}/platforms";

  cmakeFlags = [
    "-DWITH_QTWEBENGINE=True"

    "-DWITH_3D=True"
    "-DWITH_PDAL=True"
    "-DENABLE_TESTS=False"
    "-DQT_PLUGINS_DIR=${qtbase}/${qtbase.qtPluginPrefix}"

    # See https://github.com/libspatialindex/libspatialindex/issues/276
    "-DWITH_INTERNAL_SPATIALINDEX=True"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DQGIS_MACAPP_BUNDLE=0"
    "-DSQLITE3_INCLUDE_DIR=${sqlite.dev}/include"
    "-DUSE_OPENCL=OFF"
  ]
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

  # GRASS has to be available on the command line even though we baked in the
  # path at build time using GRASS_PREFIX. Using wrapGAppsHook also prevents
  # file dialogs from crashing the program on non-NixOS.
  postFixup =
    lib.optionalString (withGrass && stdenv.hostPlatform.isLinux) ''
      for program in $out/bin/*; do
        wrapProgram $program \
          "''${gappsWrapperArgs[@]}" \
          --prefix PATH : ${lib.makeBinPath [ grass ]}
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
            mkdir -p $out/Applications/QGIS.app $out/bin
            mv $out/Contents $out/Applications/QGIS.app/
            ln -s $out/Applications/QGIS.app/Contents/MacOS/qgis $out/bin/qgis

            SHORT_VERSION=$(echo "${version}" | cut -d. -f1,2)
            BUNDLE="$out/Applications/QGIS.app"
            FRAMEWORKS="$BUNDLE/Contents/Frameworks"

            for lib in "$FRAMEWORKS"/libqgis*.dylib "$FRAMEWORKS"/libqgispython*.dylib; do
              [[ -f "$lib" && ! -L "$lib" ]] || continue
              libname=$(basename "$lib")
              install_name_tool -id "$FRAMEWORKS/$libname" "$lib" 2>/dev/null || true
            done

            fix_binary() {
              local f="$1"
              [[ -f "$f" ]] || return 0
              file "$f" | grep -q "Mach-O" || return 0  # spellok

              # QGIS core libraries
              local qgis_libs=(core gui analysis 3d native app)
              for lib in "''${qgis_libs[@]}"; do
                install_name_tool \
                  -change "$out/lib/libqgis_$lib.${version}.dylib" \
                          "$FRAMEWORKS/libqgis_$lib.${version}.dylib" \
                  "$f" 2>/dev/null || true
              done

              # libqgispython (no underscore, unlike the other qgis libs)
              install_name_tool \
                -change "$out/lib/libqgispython.${version}.dylib" \
                        "$FRAMEWORKS/libqgispython.${version}.dylib" \
                "$f" 2>/dev/null || true

              # QGIS frameworks
              local qgis_frameworks=(core gui analysis 3d native)
              for fw in "''${qgis_frameworks[@]}"; do
                install_name_tool \
                  -change "@loader_path/../../../qgis_$fw.framework/qgis_$fw" \
                          "$FRAMEWORKS/qgis_$fw.framework/Versions/$SHORT_VERSION/qgis_$fw" \
                  "$f" 2>/dev/null || true
              done

              # External libraries - qscintilla
              install_name_tool \
                -change "@loader_path/../lib/libqscintilla2_qt6.dylib" \
                        "${qscintilla}/lib/libqscintilla2_qt6.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "@loader_path/../../../../MacOS/lib/libqscintilla2_qt6.dylib" \
                        "${qscintilla}/lib/libqscintilla2_qt6.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "@executable_path/lib/libqscintilla2_qt6.dylib" \
                        "${qscintilla}/lib/libqscintilla2_qt6.dylib" \
                "$f" 2>/dev/null || true

              # External libraries - qtkeychain
              install_name_tool \
                -change "@loader_path/../lib/libqt6keychain.dylib" \
                        "${qtkeychain}/lib/libqt6keychain.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "@loader_path/../../../../MacOS/lib/libqt6keychain.dylib" \
                        "${qtkeychain}/lib/libqt6keychain.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "@executable_path/lib/libqt6keychain.dylib" \
                        "${qtkeychain}/lib/libqt6keychain.dylib" \
                "$f" 2>/dev/null || true

              # External libraries - qwt
              install_name_tool \
                -change "@loader_path/../lib/libqwt.dylib" \
                        "${qwt}/lib/libqwt.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "@loader_path/../../../../MacOS/lib/libqwt.dylib" \
                        "${qwt}/lib/libqwt.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "@executable_path/lib/libqwt.dylib" \
                        "${qwt}/lib/libqwt.dylib" \
                "$f" 2>/dev/null || true
              install_name_tool \
                -change "qwt.framework/Versions/6/qwt" \
                        "${qwt}/lib/qwt.framework/Versions/6/qwt" \
                "$f" 2>/dev/null || true

              # QCA framework paths
              local qca_paths=(
                "@loader_path/../../Frameworks/qca-qt6.framework/qca-qt6"
                "@loader_path/../../../qca-qt6.framework/qca-qt6"
                "@executable_path/../Frameworks/qca-qt6.framework/qca-qt6"
              )
              for qca_path in "''${qca_paths[@]}"; do
                install_name_tool \
                  -change "$qca_path" "${qca}/lib/qca-qt6.framework/qca-qt6" \
                  "$f" 2>/dev/null || true
              done
            }

            fix_binary "$BUNDLE/Contents/MacOS/qgis"
            for bin in "$BUNDLE/Contents/MacOS"/*; do fix_binary "$bin"; done
            for lib in "$FRAMEWORKS"/*.dylib; do fix_binary "$lib"; done

            if [[ -d "$BUNDLE/Contents/MacOS/lib" ]]; then
              for lib in "$BUNDLE/Contents/MacOS/lib"/*.dylib; do fix_binary "$lib"; done
            fi

            for fw in qgis_core qgis_gui qgis_analysis qgis_3d qgis_native; do
              fix_binary "$FRAMEWORKS/$fw.framework/Versions/$SHORT_VERSION/$fw"
              [[ -f "$FRAMEWORKS/$fw.framework/$fw" && ! -L "$FRAMEWORKS/$fw.framework/$fw" ]] && \
                fix_binary "$FRAMEWORKS/$fw.framework/$fw"
            done

            for plugin in "$BUNDLE/Contents/PlugIns/qgis"/*.so; do fix_binary "$plugin"; done

            # Fix Python binding .so files in Frameworks/qgis
            for pyso in "$BUNDLE/Contents/Frameworks/qgis"/*.so; do fix_binary "$pyso"; done

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

            QGIS_PYTHON="$BUNDLE/Contents/Resources/python"
            if [[ -d "$QGIS_PYTHON" ]]; then
              for pkg in ${
                lib.concatMapStringsSep " " (p: "${p}/${py.pkgs.python.sitePackages}") (
                  py.pkgs.requiredPythonModules pythonBuildInputs
                )
              }; do
                [[ -d "$pkg" ]] && lndir -silent "$pkg" "$QGIS_PYTHON"
              done
              find "$QGIS_PYTHON" -type l ! -exec test -e {} \; -delete
            fi

            mkdir -p "$BUNDLE/Contents/PlugIns"
            lndir -silent "${qtbase}/${qtbase.qtPluginPrefix}" "$BUNDLE/Contents/PlugIns"
            lndir -silent "${qtsvg}/${qtbase.qtPluginPrefix}" "$BUNDLE/Contents/PlugIns"

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
