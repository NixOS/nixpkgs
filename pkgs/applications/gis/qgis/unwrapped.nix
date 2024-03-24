{ lib
, fetchFromGitHub
, makeWrapper
, mkDerivation
, substituteAll
, wrapGAppsHook
, wrapQtAppsHook

, withGrass ? true
, withWebKit ? false

, bison
, cmake
, draco
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
, perl
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
, xfontsel
, xvfb-run
, xorg
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      pyqt5 = super.pyqt5.override {
        withLocation = true;
        withSerialPort = true;
      };
    };
  };

  pythonBuildInputs = with py.pkgs; [
    # FIXME: remove not needed packages
    # See: https://github.com/qgis/QGIS/blob/master/.docker/qgis3-qt5-build-deps.dockerfile
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
in mkDerivation rec {
  version = "3.36.1";
  pname = "qgis-unwrapped";

  src = fetchFromGitHub {
    owner = "qgis";
    repo = "QGIS";
    rev = "final-${lib.replaceStrings [ "." ] [ "_" ] version}";
    hash = "sha256-/0wVPcQoliJFgY8Kn506gUHfY+kDTdLgzbp/0KLSAkI=";
  };

  passthru = {
    inherit pythonBuildInputs;
    inherit py;
  };

  nativeBuildInputs = [
    makeWrapper
    wrapGAppsHook
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
  ];

  # Add path to Qt platform plugins
  # (offscreen is needed by "${APIS_SRC_DIR}/generate_console_pap.py")
  preBuild = ''
    export QT_QPA_PLATFORM_PLUGIN_PATH=${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforms
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DWITH_3D=True"
    "-DWITH_PDAL=True"
    "-DENABLE_TESTS=True"
    "-DHAS_KDE_QT5_PDF_TRANSFORM_FIX=True"
    "-DHAS_KDE_QT5_SMALL_CAPS_FIX=True"
    "-DHAS_KDE_QT5_FONT_STRETCH_FIX=True"
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

  doCheck = true;

  # List of build dependencies:
  # https://github.com/qgis/QGIS/blob/master/.docker/qgis3-qt5-build-deps.dockerfile
  nativeCheckInputs = [
    wrapQtAppsHook
    python3.pkgs.nose2
    python3.pkgs.mock
    (perl.withPackages(p: [ p.YAMLTiny ]))  # required for tests/code_layout/sipify
    qtbase
    xfontsel
    xorg.xauth
    xvfb-run
  ];

  preCheck = ''
    export QT_PLUGIN_PATH="${qtbase}/${qtbase.qtPluginPrefix}"
    export QT_QPA_PLATFORM_PLUGIN_PATH=${qtbase.bin}/lib/qt-${qtbase.version}/plugins/platforms
    export QGIS_PREFIX_PATH="output"
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run -a -n 1 -s '-screen 0 1280x1024x24 -dpi 96' ctest --label-exclude POSTGRES --exclude-regex '^(${lib.concatStringsSep "|" disabledTests})$'
    runHook postCheck
  '';

  # List of excluded tests:
  # https://github.com/qgis/QGIS/blob/master/.ci/test_blocklist_qt5.txt
  # List of flaky tests:
  # https://github.com/qgis/QGIS/blob/master/.ci/test_flaky.txt
  disabledTests = [
    "ProcessingGrass7.*"
    "ProcessingOtbAlgorithmsTest"
    "ProcessingGdalAlgorithmsVectorTest"

    # Subprocess aborted
    "test_gui_queryresultwidget"
    "test_gui_filedownloader"
    "test_provider_wcsprovider"

  # Failing tests:
	#  29 - test_core_application (Failed)
	#  35 - test_core_authmanager (Failed)
	#  40 - test_core_callout (Failed)
	#  45 - test_core_colorschemeregistry (Failed)
	#  46 - test_core_compositionconverter (Failed)
	#  48 - test_core_coordinatereferencesystemregistry (Failed)
	#  54 - test_core_datadefinedsizelegend (Failed)
	#  55 - test_core_dataitem (Failed)
	#  59 - test_core_dxfexport (Failed)
	#  62 - test_core_expression (Failed)
	#  69 - test_core_fontmarker (Failed)
	#  70 - test_core_fontutils (Failed)
	#  72 - test_core_gdalutils (Failed)
	#  88 - test_core_labelingengine (Failed)
	#  99 - test_core_layoutlabel (Failed)
	# 100 - test_core_layoutmanualtable (Failed)
	# 101 - test_core_layoutmap (Failed)
	# 102 - test_core_layoutmapgrid (Failed)
	# 108 - test_core_layoutpicture (Failed)
	# 110 - test_core_layoutscalebar (Failed)
	# 112 - test_core_layouttable (Failed)
	# 114 - test_core_layoututils (Failed)
	# 115 - test_core_legendrenderer (Failed)
	# 117 - test_core_mapdevicepixelratio (Failed)
	# 121 - test_core_maprendererjob (Failed)
	# 122 - test_core_maprotation (Failed)
	# 131 - test_core_mesheditor (Failed)
	# 132 - test_core_meshlayer (Subprocess aborted)
	# 133 - test_core_meshlayerinterpolator (Failed)
	# 134 - test_core_meshlayerrenderer (Subprocess aborted)
	# 136 - test_core_networkaccessmanager (Subprocess aborted)
	# 140 - test_core_offlineediting (Subprocess aborted)
	# 148 - test_core_pallabeling (Failed)
	# 151 - test_core_pointcloudlayerexporter (Failed)
	# 157 - test_core_projectstorage (Failed)
	# 168 - test_core_rasterlayer (Failed)
	# 177 - test_core_settingsentry (Failed)
	# 191 - test_core_style (Failed)
	# 193 - test_core_svgmarker (Failed)
	# 213 - test_core_vectortilelayer (Failed)
	# 223 - test_core_coordinatereferencesystem (Failed)
	# 263 - test_gui_mapcanvas (Failed)
	# 268 - test_gui_processinggui (Failed)
	# 283 - test_gui_valuerelationwidgetwrapper (Failed)
	# 289 - test_gui_newdatabasetablewidget (Failed)
	# 293 - test_gui_meshlayerpropertiesdialog (Subprocess aborted)
	# 307 - test_3d_mesh3drendering (Failed)
	# 313 - test_analysis_processingalgspt1 (Failed)
	# 314 - test_analysis_processingalgspt2 (Failed)
	# 322 - test_analysis_meshcalculator (Subprocess aborted)
	# 323 - test_analysis_meshcontours (Subprocess aborted)
	# 325 - test_analysis_gcptransformer (Failed)
	# 326 - test_analysis_processingpdalalgs (Subprocess aborted)
	# 327 - test_analysis_processing (Failed)
	# 328 - test_geometry_checker_geometrychecks (Failed)
	# 334 - test_provider_wmsprovider (Subprocess aborted)
	# 339 - test_provider_mdalprovider (Subprocess aborted)
	# 340 - test_provider_virtualrasterprovider (Subprocess aborted)
	# 341 - test_provider_eptprovider (Failed)
	# 344 - test_provider_pdalprovider (Subprocess aborted)
	# 345 - qgis_grassprovidertest8 (Subprocess aborted)
	# 356 - test_app_layerpropertiesdialogs (Failed)
	# 359 - test_app_maptooleditannotation (Failed)
	# 360 - test_app_maptoolidentifyaction (Failed)
	# 361 - test_app_maptoollabel (Failed)
	# 367 - test_app_maptooleditmesh (Failed)
	# 382 - test_app_projectproperties (Failed)
	# 384 - test_app_meshcalculatordialog (Subprocess aborted)
	# 389 - test_app_qgisapppython (Subprocess aborted)
	# 412 - PyQgsAnnotation (Failed)
	# 433 - PyQgsBlockingProcess (Failed)
	# 460 - PyQgsConnectionRegistry (Failed)
	# 473 - PyQgsDatumTransform (Failed)
	# 488 - PyQgsExternalStorageWebDav (Failed)
	# 489 - PyQgsExternalStorageAwsS3 (Failed)
	# 494 - PyQgsFieldFormattersTest (Failed)
	# 512 - PyQgsFileUtils (Failed)
	# 520 - PyQgsGeometryGeneratorSymbolLayer (Failed)
	# 521 - PyQgsGeometryTest (Failed)
	# 530 - PyQgsGroupLayer (Failed)
	# 531 - PyQgsHashLineSymbolLayer (Failed)
	# 533 - PyQgsHighlight (Failed)
	# 547 - PyQgsLayerMetadataProviderPython (Failed)
	# 558 - PyQgsLayoutExporter (Failed)
	# 566 - PyQgsLayoutHtml (Failed)
	# 593 - PyQgsLineSymbolLayers (Failed)
	# 599 - PyQgsMapCanvas (Failed)
	# 600 - PyQgsMapCanvasAnnotationItem (Failed)
	# 636 - PyQgsNullSymbolRenderer (Failed)
	# 644 - PyQgsOGRProviderGpkg (Failed)
	# 651 - PyQgsPalLabelingBase (Failed)
	# 652 - PyQgsPalLabelingCanvas (Failed)
	# 653 - PyQgsPalLabelingLayout (Failed)
	# 654 - PyQgsPalLabelingPlacement (Failed)
	# 671 - PyQgsProcessExecutablePt1 (Failed)
	# 672 - PyQgsProcessExecutablePt2 (Failed)
	# 684 - PyQgsProjectionSelectionWidgets (Failed)
	# 693 - PyQgsProviderConnectionGpkg (Failed)
	# 694 - PyQgsProviderConnectionSpatialite (Failed)
	# 709 - PyQgsRasterAttributeTable (Failed)
	# 710 - PyQgsRasterAttributeTableModel (Failed)
	# 712 - PyQgsRasterFileWriter (Failed)
	# 714 - PyQgsRasterLayer (Failed)
	# 725 - PyQgsRasterTransparencyWidget (Failed)
	# 739 - PyQgsRubberBand (Failed)
	# 743 - PyQgsSingleSymbolRenderer (Failed)
	# 753 - PyQgsOGRProvider (Failed)
	# 765 - PyQgsSpatialiteProvider (Failed)
	# 771 - PyQgsSymbolLayerReadSld (Failed)
	# 772 - PyQgsArrowSymbolLayer (Failed)
	# 773 - PyQgsSymbolExpressionVariables (Failed)
	# 802 - PyQgsVectorFileWriter (Failed)
	# 808 - PyQgsVectorLayerEditBuffer (Failed)
	# 821 - PyQgsVirtualLayerProvider (Failed)
	# 825 - PyQgsWFSProvider (Failed)
	# 829 - PyQgsLayerDependencies (Failed)
	# 831 - PyQgsDBManagerGpkg (Failed)
	# 832 - PyQgsDBManagerSpatialite (Failed)
	# 837 - PyQgsSettingsTreeNode (Failed)
	# 842 - PyQgsAuxiliaryStorage (Failed)
	# 847 - PyQgsSelectiveMasking (Failed)
	# 855 - PyQgsRasterAttributeTableWidget (Failed)
  ];

  meta = with lib; {
    description = "A Free and Open Source Geographic Information System";
    homepage = "https://www.qgis.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; teams.geospatial.members ++ [ lsix ];
    platforms = with platforms; linux;
  };
}
