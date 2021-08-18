{ lib
, mkDerivation
, fetchFromGitHub
, fetchpatch
, cmake
, dxflib
, eigen
, flann
, gdal
, LASzip
, libLAS
, pdal
, qtbase
, qtsvg
, qttools
, tbb
, xercesc
}:

mkDerivation rec {
  pname = "cloudcompare";
  version = "2.11.2"; # Remove below patch with the next version bump.

  src = fetchFromGitHub {
    owner = "CloudCompare";
    repo = "CloudCompare";
    rev = "v${version}";
    sha256 = "0sb2h08iaf6zrf54sg6ql6wm63q5vq0kpd3gffdm26z8w6j6wv3s";
    # As of writing includes (https://github.com/CloudCompare/CloudCompare/blob/a1c589c006fc325e8b560c77340809b9c7e7247a/.gitmodules):
    # * libE57Format
    # * PoissonRecon
    # In a future version it will also contain
    # * CCCoreLib
    fetchSubmodules = true;
  };

  patches = [
    # TODO: Remove with next CloudCompare release (see https://github.com/CloudCompare/CloudCompare/pull/1478)
    (fetchpatch {
      name = "CloudCompare-fix-for-PDAL-2.3.0.patch";
      url = "https://github.com/CloudCompare/CloudCompare/commit/f3038dcdeb0491c4a653c2ee6fb017326eb676a3.patch";
      sha256 = "0ca5ry987mcgsdawz5yd4xhbsdb5k44qws30srxymzx2djvamwli";
    })
  ];

  nativeBuildInputs = [
    cmake
    eigen # header-only
  ];

  buildInputs = [
    dxflib
    flann
    gdal
    LASzip
    libLAS
    pdal
    qtbase
    qtsvg
    qttools
    tbb
    xercesc
  ];

  cmakeFlags = [
    # TODO: This will become -DCCCORELIB_USE_TBB=ON in a future version, see
    #       https://github.com/CloudCompare/CloudCompare/commit/f5a0c9fd788da26450f3fa488b2cf0e4a08d255f
    "-DCOMPILE_CC_CORE_LIB_WITH_TBB=ON"
    "-DOPTION_USE_DXF_LIB=ON"
    "-DOPTION_USE_GDAL=ON"
    "-DOPTION_USE_SHAPE_LIB=ON"

    "-DPLUGIN_GL_QEDL=ON"
    "-DPLUGIN_GL_QSSAO=ON"
    "-DPLUGIN_IO_QADDITIONAL=ON"
    "-DPLUGIN_IO_QCORE=ON"
    "-DPLUGIN_IO_QCSV_MATRIX=ON"
    "-DPLUGIN_IO_QE57=ON"
    "-DPLUGIN_IO_QFBX=OFF" # Autodesk FBX SDK is gratis+proprietary; not packaged in nixpkgs
    "-DPLUGIN_IO_QPDAL=ON" # required for .las/.laz support
    "-DPLUGIN_IO_QPHOTOSCAN=ON"
    "-DPLUGIN_IO_QRDB=OFF" # Riegl rdblib is proprietary; not packaged in nixpkgs
  ];

  meta = with lib; {
    description = "3D point cloud and mesh processing software";
    homepage = "https://cloudcompare.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nh2 ];
    platforms = with platforms; linux; # only tested here; might work on others
  };
}
