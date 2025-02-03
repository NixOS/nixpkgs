{ lib, stdenv, fetchurl, cmake, curl, Accelerate, CoreGraphics, CoreVideo
, fftwSinglePrec, netcdf, pcre, gdal, blas, lapack, glibc, ghostscript, dcw-gmt
, gshhg-gmt }:

/* The onus is on the user to also install:
    - ffmpeg for webm or mp4 output
    - graphicsmagick for gif output
*/

stdenv.mkDerivation rec {
  pname = "gmt";
  version = "6.4.0";
  src = fetchurl {
    url = "https://github.com/GenericMappingTools/gmt/releases/download/${version}/gmt-${version}-src.tar.gz";
    sha256 = "sha256-0mfAx9b7MMnqfgKe8n2tsm/9e5LLS0cD+aO6Do85Ohs=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ curl gdal netcdf pcre dcw-gmt gshhg-gmt ]
    ++ (if stdenv.hostPlatform.isDarwin then [
      Accelerate
      CoreGraphics
      CoreVideo
    ] else [
      glibc
      fftwSinglePrec
      blas
      lapack
    ]);

  propagatedBuildInputs = [ ghostscript ];

  cmakeFlags = [
    "-DGMT_DOCDIR=share/doc/gmt"
    "-DGMT_MANDIR=share/man"
    "-DGMT_LIBDIR=lib"
    "-DCOPY_GSHHG:BOOL=FALSE"
    "-DGSHHG_ROOT=${gshhg-gmt.out}/share/gshhg-gmt"
    "-DCOPY_DCW:BOOL=FALSE"
    "-DDCW_ROOT=${dcw-gmt.out}/share/dcw-gmt"
    "-DGDAL_ROOT=${gdal.out}"
    "-DNETCDF_ROOT=${netcdf.out}"
    "-DPCRE_ROOT=${pcre.out}"
    "-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE"
    "-DGMT_ENABLE_OPENMP:BOOL=TRUE"
    "-DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE"
    "-DLICENSE_RESTRICTED=LGPL" # "GPL" and "no" also valid
  ] ++ (with stdenv;
    lib.optionals (!isDarwin) [
      "-DFFTW3_ROOT=${fftwSinglePrec.dev}"
      "-DLAPACK_LIBRARY=${lapack}/lib/liblapack.so"
      "-DBLAS_LIBRARY=${blas}/lib/libblas.so"
    ]);

  meta = with lib; {
    homepage = "https://www.generic-mapping-tools.org";
    description = "Tools for manipulating geographic and cartesian data sets";
    longDescription = ''
      GMT is an open-source collection of command-line tools for manipulating
      geographic and Cartesian data sets (including filtering, trend fitting,
      gridding, projecting, etc.) and producing high-quality illustrations
      ranging from simple x–y plots via contour maps to artificially illuminated
      surfaces and 3D perspective views. It supports many map projections and
      transformations and includes supporting data such as coastlines, rivers,
      and political boundaries and optionally country polygons.
    '';
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ tviti ];
  };

}
