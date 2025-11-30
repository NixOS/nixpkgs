{
  lib,
  stdenv,
  callPackage,
  fetchFromGitHub,
  fetchpatch,

  useMinimalFeatures ? false,
  useArmadillo ? (!useMinimalFeatures),
  useArrow ? (!useMinimalFeatures),
  useHDF ? (!useMinimalFeatures),
  useJava ? (!useMinimalFeatures),
  useLibAvif ? (!useMinimalFeatures),
  useLibHEIF ? (!useMinimalFeatures),
  useLibJXL ? (!useMinimalFeatures),
  useMysql ? (!useMinimalFeatures),
  useNetCDF ? (!useMinimalFeatures),
  usePoppler ? (!useMinimalFeatures),
  usePostgres ? (!useMinimalFeatures),
  useTiledb ?
    (!useMinimalFeatures) && !(stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64),

  ant,
  armadillo,
  arrow-cpp,
  bison,
  brunsli,
  c-blosc,
  cfitsio,
  cmake,
  crunch,
  cryptopp,
  curl,
  dav1d,
  doxygen,
  expat,
  geos,
  giflib,
  graphviz,
  gtest,
  hdf4,
  hdf5-cpp,
  jdk,
  json_c,
  lerc,
  libaom,
  libavif,
  libde265,
  libdeflate,
  libgeotiff,
  libheif,
  libhwy,
  libiconv,
  libjpeg,
  libjxl,
  libmysqlclient,
  libpq,
  libpng,
  libspatialite,
  libtiff,
  libwebp,
  libxml2,
  lz4,
  netcdf,
  openexr,
  openjpeg,
  openssl,
  pcre2,
  pkg-config,
  poppler,
  proj,
  python3,
  qhull,
  rav1e,
  sqlite,
  swig,
  tiledb,
  x265,
  xercesc,
  xz,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gdal" + lib.optionalString useMinimalFeatures "-minimal";
  version = "3.11.4";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CFQF3vDhhXsAnIfUcn6oTQ4Xm+GH/36dqSGc0HvyEJ0=";
  };

  patches = [
    (fetchpatch {
      name = "fix-build-poppler-25.10.0.patch";
      url = "https://github.com/OSGeo/gdal/commit/a716a6cd5ffd779b30950f046fce91878fc97b9d.patch";
      hash = "sha256-dSotpnTiMjt3Bz63hpNjF5juZ3JsjIpD59/67cR9rNU=";
    })
  ];

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    graphviz
    pkg-config
    python3.pkgs.setuptools
    python3.pkgs.wrapPython
    swig
  ]
  ++ lib.optionals useJava [
    ant
    jdk
  ];

  cmakeFlags = [
    "-DGDAL_USE_INTERNAL_LIBS=OFF"
    "-DGEOTIFF_INCLUDE_DIR=${lib.getDev libgeotiff}/include"
    "-DGEOTIFF_LIBRARY_RELEASE=${lib.getLib libgeotiff}/lib/libgeotiff${stdenv.hostPlatform.extensions.sharedLibrary}"
    "-DMYSQL_INCLUDE_DIR=${lib.getDev libmysqlclient}/include/mysql"
    "-DMYSQL_LIBRARY=${lib.getLib libmysqlclient}/lib/${
      lib.optionalString (libmysqlclient.pname != "mysql") "mysql/"
    }libmysqlclient${stdenv.hostPlatform.extensions.sharedLibrary}"
  ]
  ++ lib.optionals finalAttrs.doInstallCheck [
    "-DBUILD_TESTING=ON"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    "-DCMAKE_SKIP_BUILD_RPATH=ON" # without, libgdal.so can't find libmariadb.so
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON"
  ]
  ++ lib.optionals (!useTiledb) [
    "-DGDAL_USE_TILEDB=OFF"
  ]
  ++ lib.optionals (!useJava) [
    # This is not strictly needed as the Java bindings wouldn't build anyway if
    # ant/jdk were not available.
    "-DBUILD_JAVA_BINDINGS=OFF"
  ];

  buildInputs =
    let
      tileDbDeps = lib.optionals useTiledb [ tiledb ];
      libAvifDeps = lib.optionals useLibAvif [ libavif ];
      libHeifDeps = lib.optionals useLibHEIF [
        libheif
        dav1d
        libaom
        libde265
        rav1e
        x265
      ];
      libJxlDeps = lib.optionals useLibJXL [
        libjxl
        libhwy
      ];
      mysqlDeps = lib.optionals useMysql [ libmysqlclient ];
      postgresDeps = lib.optionals usePostgres [ libpq ];
      popplerDeps = lib.optionals usePoppler [ poppler ];
      arrowDeps = lib.optionals useArrow [ arrow-cpp ];
      hdfDeps = lib.optionals useHDF [
        hdf4
        hdf5-cpp
      ];
      netCdfDeps = lib.optionals useNetCDF [ netcdf ];
      armadilloDeps = lib.optionals useArmadillo [ armadillo ];

      darwinDeps = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];
      nonDarwinDeps = lib.optionals (!stdenv.hostPlatform.isDarwin) (
        [
          # tests for formats enabled by these packages fail on macos
          openexr
          xercesc
        ]
        ++ arrowDeps
      );
    in
    [
      c-blosc
      brunsli
      cfitsio
      crunch
      curl
      cryptopp
      libdeflate
      expat
      libgeotiff
      geos
      giflib
      libjpeg
      json_c
      lerc
      xz
      libxml2
      lz4
      openjpeg
      openssl
      pcre2
      libpng
      proj
      qhull
      libspatialite
      sqlite
      libtiff
      gtest
      libwebp
      zlib
      zstd
      python3
      python3.pkgs.numpy
    ]
    ++ tileDbDeps
    ++ libAvifDeps
    ++ libHeifDeps
    ++ libJxlDeps
    ++ mysqlDeps
    ++ postgresDeps
    ++ popplerDeps
    ++ arrowDeps
    ++ hdfDeps
    ++ netCdfDeps
    ++ armadilloDeps
    ++ darwinDeps
    ++ nonDarwinDeps;

  pythonPath = [ python3.pkgs.numpy ];
  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out $pythonPath"
  ''
  + lib.optionalString useJava ''
    cd $out/lib
    ln -s ./jni/libgdalalljni${stdenv.hostPlatform.extensions.sharedLibrary}
    cd -
  '';

  enableParallelBuilding = true;

  doInstallCheck = true;
  # preCheck rather than preInstallCheck because this is what pytestCheckHook
  # calls (coming from the python world)
  preCheck = ''
    pushd autotest

    export HOME=$(mktemp -d)
    export PYTHONPATH="$out/${python3.sitePackages}:$PYTHONPATH"
    export GDAL_DOWNLOAD_TEST_DATA=OFF
    # allows to skip tests that fail because of file handle leak
    # the issue was not investigated
    # https://github.com/OSGeo/gdal/blob/v3.9.0/autotest/gdrivers/bag.py#L54
    export CI=1
  '';
  nativeInstallCheckInputs = with python3.pkgs; [
    pytestCheckHook
    pytest-benchmark
    pytest-env
    filelock
    lxml
  ];
  pytestFlags = [
    "--benchmark-disable"
  ];
  disabledTestPaths = [
    # tests that attempt to make network requests
    "gcore/vsis3.py"
    "gdrivers/gdalhttp.py"
    "gdrivers/wms.py"
  ];
  disabledTests = [
    # tests that attempt to make network requests
    "test_jp2openjpeg_45"
    # tests that require the full proj dataset which we don't package yet
    # https://github.com/OSGeo/gdal/issues/5523
    "test_transformer_dem_overrride_srs"
    "test_osr_ct_options_area_of_interest"
    # ZIP does not support timestamps before 1980
    "test_sentinel2_zipped"
    # tries to call unwrapped executable
    "test_SetPROJAuxDbPaths"
    # failing for unknown reason
    # https://github.com/OSGeo/gdal/pull/10806#issuecomment-2362054085
    "test_ogr_gmlas_billion_laugh"
    # Flaky on hydra, collected in https://github.com/NixOS/nixpkgs/pull/327323.
    "test_ogr_gmlas_huge_processing_time"
    "test_ogr_gpkg_background_rtree_build"
    "test_vsiaz_fake_write"
    "test_vsioss_6"
    # flaky?
    "test_tiledb_read_arbitrary_array"
    # tests for magic numbers, seem to change with different poppler versions,
    # and architectures
    "test_pdf_extra_rasters"
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isx86_64) [
    # likely precision-related expecting x87 behaviour
    "test_jp2openjpeg_22"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky on macos
    "test_rda_download_queue"
    # https://github.com/OSGeo/gdal/commit/fa0ac7544af837613e9831d4d2841dd6bf735e1f
    "test_ogr_gpkg_arrow_stream_huge_array"
  ]
  ++ lib.optionals (lib.versionOlder proj.version "8") [
    "test_ogr_parquet_write_crs_without_id_in_datum_ensemble_members"
  ]
  ++ lib.optionals (!usePoppler) [
    "test_pdf_jpx_compression"
  ];
  postCheck = ''
    popd # autotest
  '';

  passthru.tests = callPackage ./tests.nix { gdal = finalAttrs.finalPackage; };

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    changelog = "https://github.com/OSGeo/gdal/blob/${finalAttrs.src.tag}/NEWS.md";
    description = "Translator library for raster geospatial data formats";
    homepage = "https://www.gdal.org/";
    license = licenses.mit;
    maintainers = with maintainers; [
      marcweber
      dotlambda
    ];
    teams = [ teams.geospatial ];
    platforms = platforms.unix;
  };
})
