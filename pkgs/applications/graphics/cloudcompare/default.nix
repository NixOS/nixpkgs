{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, dxflib
, eigen
, flann
, gdal
, LASzip
, libLAS
, pdal
, pcl
, qtbase
, qtsvg
, qttools
, tbb
, xercesc
}:

mkDerivation rec {
  pname = "cloudcompare";
  # Released version(v2.11.3) doesn't work with packaged PCL.
  version = "unstable-2021-10-14";

  src = fetchFromGitHub {
    owner = "CloudCompare";
    repo = "CloudCompare";
    rev = "1f65ba63756e23291ae91ff52d04da468ade8249";
    sha256 = "x1bDjFjXIl3r+yo1soWvRB+4KGP50/WBoGlrH013JQo=";
    # As of writing includes (https://github.com/CloudCompare/CloudCompare/blob/a1c589c006fc325e8b560c77340809b9c7e7247a/.gitmodules):
    # * libE57Format
    # * PoissonRecon
    # * CCCoreLib
    fetchSubmodules = true;
  };

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
    pcl
    qtbase
    qtsvg
    qttools
    tbb
    xercesc
  ];

  cmakeFlags = [
    "-DCCCORELIB_USE_TBB=ON"
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

    "-DPLUGIN_STANDARD_QPCL=ON" # Adds PCD import and export support
  ];

  meta = with lib; {
    description = "3D point cloud and mesh processing software";
    homepage = "https://cloudcompare.org";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nh2 ];
    platforms = with platforms; linux; # only tested here; might work on others
  };
}
