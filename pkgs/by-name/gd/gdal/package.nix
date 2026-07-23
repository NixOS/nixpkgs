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
  python3Packages,
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
  buildPackages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gdal" + lib.optionalString useMinimalFeatures "-minimal";
  version = "3.12.4";

  src = fetchFromGitHub {
    owner = "OSGeo";
    repo = "gdal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sD/ZAOvMWK2+AGw6wgziDsheH+hwUwhd7i2f65cjFKg=";
  };

  patches = [
    # Fix build against Poppler >= 26.06 (not yet backported to the 3.12.x branch upstream)
    # https://github.com/OSGeo/gdal/issues/14714
    (fetchpatch {
      name = "0001- poppler-add-compatibility-with-future-26.06.patch";
      url = "https://github.com/OSGeo/gdal/commit/cbad3ef7824dcad235e95581127dbc4df696d6d3.patch";
      hash = "sha256-tJsUcBorYDF0eNzKMHDc+qUvovlIQ7WrRsePbmKmIT8=";
    })
    (fetchpatch {
      name = "0002-poppler-add-compatibility-with-future-26.06-continuation.patch";
      url = "https://github.com/OSGeo/gdal/commit/b3f839f2515b023e4a7cf099b7ce1626ccb24eac.patch";
      hash = "sha256-XtYUjulIiOknIE5e7AcRCThPvmSLP0QRbONUBF+KTxE=";
    })
    (fetchpatch {
      name = "0003-pdf-fix-build-against-latest-poppler.patch";
      url = "https://github.com/OSGeo/gdal/commit/581a86960d68e426b50384ed6e45ecb935f0f2a1.patch";
      hash = "sha256-VsOq+lQ6QhXKHFOeqdGFXRmtFR90FOJyTdYK5NFgB5U=";
    })
    (fetchpatch {
      name = "0004-pdf-fix-build-against-poppler-26.05.99dev.patch";
      url = "https://github.com/OSGeo/gdal/commit/7b8b8de28bbd200b0fd3b09147fdc68b5bf5ce20.patch";
      hash = "sha256-BxWMpiUwM3h7Vo9vxJ4H4A8aQfE3jcSRfRYwaLw/60w=";
    })

    # Fix stack buffer overflow in netCDF driver
    # https://github.com/OSGeo/gdal/issues/14594
    (fetchpatch {
      name = "0005-netcdf-avoid-reading-attributes-without-checking-length.patch";
      url = "https://github.com/OSGeo/gdal/commit/50eea7456d83c9586f112ef96b43249372839dea.patch";
      hash = "sha256-m1FsBC37h2uuaEeYezPZJFsDR6Ix/FDIZnuZZiSAYcw=";
    })

    # Fix tests with libtiff 4.7.2
    # FAILED gcore/tiff_read.py::test_tiff_read_stripbytecounts_count_not_same_as_stripoffsets_count -
    #     AssertionError: assert '170' is None
    (fetchpatch {
      name = "0006-Internal-libtiff-resync-with-4.7.2rc3-and-adjust-tes.patch";
      url = "https://github.com/OSGeo/gdal/commit/06ffb0333fe557cde262aa1e81466dda42684c53.patch";
      hash = "sha256-teZ9cv8JQ2ua4tEWl3I8D9DYo8srGIBYIc2NfkgNMe4=";
      includes = [ "autotest/gcore/tiff_read.py" ];
    })
  ];

  nativeBuildInputs = [
    bison
    cmake
    doxygen
    graphviz
    pkg-config
    python3Packages.setuptools
    python3Packages.wrapPython
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
  ]
  ++ lib.optionals (!stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    "-DCMAKE_CROSSCOMPILING_EMULATOR=${stdenv.hostPlatform.emulator buildPackages}"
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
      python3Packages.python
      python3Packages.numpy
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

  pythonPath = [ python3Packages.numpy ];
  postInstall = ''
    wrapPythonProgramsIn "$out/bin" "$out ''${pythonPath[*]}"
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
    export PYTHONPATH="$out/${python3Packages.python.sitePackages}:$PYTHONPATH"
    export GDAL_DOWNLOAD_TEST_DATA=OFF
    # allows to skip tests that fail because of file handle leak
    # the issue was not investigated
    # https://github.com/OSGeo/gdal/blob/v3.9.0/autotest/gdrivers/bag.py#L54
    export CI=1
  '';
  nativeInstallCheckInputs = with python3Packages; [
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Trace/BPT trap: 5 on macOS
    "gcore/hdf4multidim.py"
  ];
  disabledTests = [
    # tests that attempt to make network requests
    "test_jp2openjpeg_45"
    "test_ogr_gmlas_datetime"
    "test_vrtrawlink_GDAL_VRT_RAWRASTERBAND_ALLOWED_SOURCE_ONLY_REMOTE_accepted"
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

  meta = {
    changelog = "https://github.com/OSGeo/gdal/blob/${finalAttrs.src.tag}/NEWS.md";
    description = "Translator library for raster geospatial data formats";
    homepage = "https://www.gdal.org/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
})
