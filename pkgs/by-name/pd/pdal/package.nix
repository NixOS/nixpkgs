{
  lib,
  stdenv,
  callPackage,
  ctestCheckHook,
  fetchFromGitHub,
  testers,

  enableE57 ? lib.meta.availableOn stdenv.hostPlatform libe57format,

  cmake,
  curl,
  gdal,
  gtest,
  hdf5-cpp,
  laszip,
  libe57format,
  libgeotiff,
  libpq,
  libtiff,
  libxml2,
  openscenegraph,
  pkg-config,
  proj,
  sqlite,
  tiledb,
  xercesc,
  zlib,
  zstd,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdal";
  version = "2.9.3";

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    tag = finalAttrs.version;
    hash = "sha256-htuvNheRwzpdSKc4FbwugBWWaCNC7/20TSKwRpLr+7Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    gdal
    gtest
    hdf5-cpp
    laszip
    libgeotiff
    libpq
    libtiff
    libxml2
    openscenegraph
    proj
    sqlite
    tiledb
    xercesc
    zlib
    zstd
  ]
  ++ lib.optionals enableE57 [
    libe57format
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_PLUGIN_E57=${if enableE57 then "ON" else "OFF"}"
    "-DBUILD_PLUGIN_HDF=ON"
    "-DBUILD_PLUGIN_PGPOINTCLOUD=ON"
    "-DBUILD_PLUGIN_TILEDB=ON"
    "-DWITH_COMPLETION=ON"
    "-DWITH_TESTS=ON"
    "-DBUILD_PGPOINTCLOUD_TESTS=OFF"

    # Plugins can probably not be made work easily:
    "-DBUILD_PLUGIN_CPD=OFF"
    "-DBUILD_PLUGIN_FBX=OFF" # Autodesk FBX SDK is gratis+proprietary; not packaged in nixpkgs
    "-DBUILD_PLUGIN_GEOWAVE=OFF"
    "-DBUILD_PLUGIN_I3S=OFF"
    "-DBUILD_PLUGIN_ICEBRIDGE=OFF"
    "-DBUILD_PLUGIN_MATLAB=OFF"
    "-DBUILD_PLUGIN_MBIO=OFF"
    "-DBUILD_PLUGIN_MRSID=OFF"
    "-DBUILD_PLUGIN_NITF=OFF"
    "-DBUILD_PLUGIN_OCI=OFF"
    "-DBUILD_PLUGIN_RDBLIB=OFF" # Riegl rdblib is proprietary; not packaged in nixpkgs
    "-DBUILD_PLUGIN_RIVLIB=OFF"
  ];

  doCheck = true;
  # tests are flaky and they seem to fail less often when they don't run in
  # parallel
  enableParallelChecking = false;

  disabledTests = [
    # Tests failing due to TileDB library implementation, disabled also
    # by upstream CI.
    # See: https://github.com/PDAL/PDAL/blob/2.9.3/.github/workflows/linux.yml#L81
    "pdal_io_tiledb_writer_test"
    "pdal_io_tiledb_reader_test"
    "pdal_io_tiledb_time_writer_test"
    "pdal_io_tiledb_time_reader_test"
    "pdal_io_tiledb_bit_fields_test"
    "pdal_io_tiledb_utils_test"
    "pdal_io_e57_read_test"
    "pdal_io_e57_write_test"
    "pdal_io_stac_reader_test"

    # Require data to be downloaded from Internet
    "pdal_io_copc_reader_test"
  ];

  nativeCheckInputs = [
    gdal # gdalinfo
    ctestCheckHook
  ];

  postInstall = ''
    patchShebangs --update --build $out/bin/pdal-config
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pdal --version";
      version = "pdal ${finalAttrs.finalPackage.version}";
    };
    pdal = callPackage ./tests.nix { pdal = finalAttrs.finalPackage; };
    pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
    };
  };

  meta = with lib; {
    description = "Point Data Abstraction Library. GDAL for point cloud data";
    homepage = "https://pdal.io";
    license = licenses.bsd3;
    teams = [ teams.geospatial ];
    platforms = platforms.all;
    pkgConfigModules = [ "pdal" ];
  };
})
