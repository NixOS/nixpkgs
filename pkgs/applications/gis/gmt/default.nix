{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  curl,
  Accelerate,
  CoreGraphics,
  CoreVideo,
  fftwSinglePrec,
  netcdf,
  libxml2,
  pcre,
  gdal,
  blas,
  lapack,
  glibc,
  ghostscript,
  dcw-gmt,
  gshhg-gmt,
}:

/*
  The onus is on the user to also install:
   - ffmpeg for webm or mp4 output
   - graphicsmagick for gif output
*/

let
  # Certainly not an ideal situation, See:
  # https://github.com/NixOS/nixpkgs/pull/340707#issuecomment-2361894717
  netcdf' = netcdf.override {
    libxml2 = libxml2.override {
      enableHttp = true;
    };
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "gmt";
  version = "6.5.0";
  src = fetchFromGitHub {
    owner = "GenericMappingTools";
    repo = "gmt";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-KKIYhljCtk9t9CuvTLsSGvUkUwazWTm9ymBB3wLwSoI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs =
    [
      curl
      gdal
      netcdf'
      pcre
      dcw-gmt
      gshhg-gmt
    ]
    ++ (
      if stdenv.hostPlatform.isDarwin then
        [
          Accelerate
          CoreGraphics
          CoreVideo
        ]
      else
        [
          glibc
          fftwSinglePrec
          blas
          lapack
        ]
    );

  propagatedBuildInputs = [
    ghostscript
  ];

  cmakeFlags =
    [
      "-DGMT_DOCDIR=share/doc/gmt"
      "-DGMT_MANDIR=share/man"
      "-DGMT_LIBDIR=lib"
      "-DCOPY_GSHHG:BOOL=FALSE"
      "-DGSHHG_ROOT=${gshhg-gmt.out}/share/gshhg-gmt"
      "-DCOPY_DCW:BOOL=FALSE"
      "-DDCW_ROOT=${dcw-gmt.out}/share/dcw-gmt"
      "-DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE"
      "-DGMT_ENABLE_OPENMP:BOOL=TRUE"
      "-DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE"
      "-DLICENSE_RESTRICTED=LGPL" # "GPL" and "no" also valid
    ];

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
