{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  apple-sdk,
  fftwSinglePrec,
  netcdf,
  pcre,
  gdal,
  blas,
  lapack,
  ghostscript,
  dcw-gmt,
  gshhg-gmt,
  libxml2,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gmt";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "gmt";
    tag = finalAttrs.version;
    hash = "sha256-ODJwnjZjWpR5Dg0gNimtrOCCgseJ8INfKEBKP7/bYIc=";
  };

  nativeBuildInputs = [ cmake ];

  env = {
    NIX_LDFLAGS = "-lxml2 -L${lib.getLib libxml2}/lib";
    NIX_CFLAGS_COMPILE =
      lib.optionalString stdenv.cc.isClang "-Wno-implicit-function-declaration "
      + lib.optionalString (
        stdenv.hostPlatform.isDarwin && lib.versionOlder apple-sdk.version "13.3"
      ) "-D__LAPACK_int=int";
  };

  buildInputs = [
    curl
    gdal
    netcdf
    pcre
    dcw-gmt
    gshhg-gmt
  ]
  ++ lib.optionals (!stdenv.hostPlatform.isDarwin) [
    fftwSinglePrec
    blas
    lapack
  ];

  propagatedBuildInputs = [ ghostscript ];

  cmakeFlags = [
    (lib.cmakeFeature "GMT_DOCDIR" "share/doc/gmt")
    (lib.cmakeFeature "GMT_MANDIR" "share/man")
    (lib.cmakeFeature "GMT_LIBDIR" "lib")
    (lib.cmakeBool "COPY_GSHHG" false)
    (lib.cmakeFeature "GSHHG_ROOT" "${gshhg-gmt.out}/share/gshhg-gmt")
    (lib.cmakeBool "COPY_DCW" false)
    (lib.cmakeFeature "DCW_ROOT" "${dcw-gmt.out}/share/dcw-gmt")
    (lib.cmakeFeature "GDAL_ROOT" "${gdal.out}")
    (lib.cmakeFeature "NETCDF_ROOT" "${netcdf.out}")
    (lib.cmakeFeature "PCRE_ROOT" "${pcre.out}")
    (lib.cmakeBool "GMT_INSTALL_TRADITIONAL_FOLDERNAMES" false)
    (lib.cmakeBool "GMT_ENABLE_OPENMP" true)
    (lib.cmakeBool "GMT_INSTALL_MODULE_LINKS" false)
    (lib.cmakeFeature "LICENSE_RESTRICTED" "LGPL")
  ]
  ++ (lib.optionals (!stdenv.hostPlatform.isDarwin) [
    (lib.cmakeFeature "FFTW3_ROOT" "${fftwSinglePrec.dev}")
    (lib.cmakeFeature "LAPACK_LIBRARY" "${lib.getLib lapack}/lib/liblapack.so")
    (lib.cmakeFeature "BLAS_LIBRARY" "${lib.getLib blas}/lib/libblas.so")
  ]);

  meta = {
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
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ tviti ];
  };
})
