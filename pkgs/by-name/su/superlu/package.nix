{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  ninja,
  gfortran,
  blas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "superlu";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "xiaoyeli";
    repo = "superlu";
    tag = "v${finalAttrs.version}";
    # Remove non‐free files.
    #
    # See:
    # * <https://github.com/xiaoyeli/superlu/issues/9>
    # * <https://github.com/xiaoyeli/superlu/blob/0bbd6571bd839d866bff6a8ff1eaa812a8c31463/License.txt#L32-L65>
    # * <https://salsa.debian.org/science-team/superlu/-/blob/0acab1b41f332f2f2e3b0b5d28ba7fc9f7539533/debian/copyright>
    postFetch = "rm $out/SRC/mc64ad.* $out/DOC/*.pdf";
    hash = "sha256-MiQPhYIGZbvmtpIojrNzTG4Xao7lc4Ks/FtxlfdAKmQ=";
  };

  patches = [
    (fetchurl {
      url = "https://salsa.debian.org/science-team/superlu/-/raw/fae141179928d1cc5a8e381503e8b1264d297c3d/debian/patches/mc64ad-stub.patch";
      hash = "sha256-QUaNUDaRghTqr6jk1TE6a7CdXABqu7xAkYZDhL/lZBQ=";
    })
  ];

  # Prevent clang from crashing when compiling slatms.c from SuperLU’s matgen test code.
  postPatch = lib.optionalString stdenv.cc.isClang ''
    echo 'target_compile_options(matgen PRIVATE -fno-vectorize)' >> TESTING/MATGEN/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    ninja
    gfortran
  ];

  propagatedBuildInputs = [ blas ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "enable_fortran" true)
    # prevent cmake from using Accelerate, which causes tests to segfault
    # https://github.com/xiaoyeli/superlu/issues/155
    (lib.cmakeFeature "BLA_VENDOR" "Generic")
  ];

  doCheck = true;

  meta = {
    homepage = "https://portal.nersc.gov/project/sparse/superlu/";
    license = [
      lib.licenses.bsd3Lbnl

      # Xerox code; actually `Boehm-GC` variant.
      lib.licenses.mit

      # University of Minnesota example files.
      lib.licenses.gpl2Plus

      # University of Florida code; permissive COLAMD licence.
      lib.licenses.free
    ];
    description = "Library for the solution of large, sparse, nonsymmetric systems of linear equations";
    platforms = lib.platforms.unix;
  };
})
