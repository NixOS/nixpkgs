{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  lapack,
  which,
  gfortran,
  blas,
  ctestCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qrupdate";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "mpimd-csc";
    repo = "qrupdate-ng";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dHxLPrN00wwozagY2JyfZkD3sKUD2+BcnbjNgZepzFg=";
  };

  cmakeFlags =
    assert (blas.isILP64 == lapack.isILP64);
    [
      "-DCMAKE_Fortran_FLAGS=${
        toString (
          [
            "-std=legacy"
          ]
          ++ lib.optionals blas.isILP64 [
            # If another application intends to use qrupdate compiled with blas with
            # 64 bit support, it should add this to it's FFLAGS as well. See (e.g):
            # https://savannah.gnu.org/bugs/?50339
            "-fdefault-integer-8"
          ]
        )
      }"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # prevent cmake from using Accelerate, which causes all tests to segfault
      "-DBLA_VENDOR=Generic"
    ];

  postPatch = ''
    sed '/^cmake_minimum_required/Is/VERSION [0-9]\.[0-9]/VERSION 3.5/' -i ./CMakeLists.txt
  '';

  doCheck = true;

  nativeBuildInputs = [
    cmake
    which
    gfortran
  ];

  buildInputs = [
    blas
    lapack
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  disabledTests =
    lib.optionals (stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux) [
      # https://github.com/mpimd-csc/qrupdate-ng/issues/7
      "test_tchshx"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isx86_64 && stdenv.hostPlatform.isDarwin) [
      # https://github.com/mpimd-csc/qrupdate-ng/issues/4
      "test_tch1dn"
    ];

  meta = {
    description = "Library for fast updating of qr and cholesky decompositions";
    homepage = "https://github.com/mpimd-csc/qrupdate-ng";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.unix;
  };
})
