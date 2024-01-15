{ lib
, stdenv
, callPackage
, fetchFromGitHub
, testers

, enableE57 ? lib.meta.availableOn stdenv.hostPlatform libe57format

, cmake
, curl
, gdal
, hdf5-cpp
, LASzip
, libe57format
, libgeotiff
, libtiff
, libxml2
, openscenegraph
, pkg-config
, postgresql
, tiledb
, xercesc
, zlib
, zstd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pdal";
  version = "2.5.6";

  src = fetchFromGitHub {
    owner = "PDAL";
    repo = "PDAL";
    rev = finalAttrs.version;
    sha256 = "sha256-JKwa89c05EfZ/FxOkj8lYmw0o2EgSqafRDIV2mTpZ5E=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    curl
    gdal
    hdf5-cpp
    LASzip
    libgeotiff
    libtiff
    libxml2
    openscenegraph
    postgresql
    tiledb
    xercesc
    zlib
    zstd
  ] ++ lib.optionals enableE57 [
    libe57format
  ];

  cmakeFlags = [
    "-DBUILD_PLUGIN_E57=${if enableE57 then "ON" else "OFF"}"
    "-DBUILD_PLUGIN_HDF=ON"
    "-DBUILD_PLUGIN_PGPOINTCLOUD=ON"
    "-DBUILD_PLUGIN_TILEDB=ON"
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

  disabledTests = [
    # Tests failing due to TileDB library implementation, disabled also
    # by upstream CI.
    # See: https://github.com/PDAL/PDAL/blob/bc46bc77f595add4a6d568a1ff923d7fe20f7e74/.github/workflows/linux.yml#L81
    "pdal_io_tiledb_writer_test"
    "pdal_io_tiledb_reader_test"
    "pdal_io_tiledb_time_writer_test"
    "pdal_io_tiledb_time_reader_test"
    "pdal_io_tiledb_bit_fields_test"
    "pdal_io_e57_read_test"
    "pdal_io_e57_write_test"
    "pdal_io_stac_reader_test"

    # Segfault
    "pdal_io_hdf_reader_test"

    # Failure
    "pdal_app_plugin_test"
  ];

  checkPhase = ''
    runHook preCheck
    # tests are flaky and they seem to fail less often when they don't run in
    # parallel
    ctest -j 1 --output-on-failure -E '^${lib.concatStringsSep "|" finalAttrs.disabledTests}$'
    runHook postCheck
  '';

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "pdal --version";
      version = "pdal ${finalAttrs.finalPackage.version}";
    };
    pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "PDAL is Point Data Abstraction Library. GDAL for point cloud data";
    homepage = "https://pdal.io";
    license = licenses.bsd3;
    maintainers = teams.geospatial.members;
    platforms = platforms.all;
    pkgConfigModules = [ "pdal" ];
  };
})
