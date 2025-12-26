{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gfortran,
  python3,
  blas,
  lapack,
  suitesparse,
  nix-update-script,
  lapackSupport ? true,
  kluSupport ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sundials";
  version = "7.5.0";

  outputs = [
    "out"
    "examples"
  ];

  src = fetchFromGitHub {
    owner = "LLNL";
    repo = "sundials";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZyUTFaMEbfNtR9oGIy0fQ+qQwb3hQ7CxTv9IevkeidE=";
  };

  nativeBuildInputs = [
    cmake
    gfortran
  ];

  buildInputs = [
    python3
  ]
  ++
    lib.optionals lapackSupport
      # Check that the same index size is used for both libraries
      (
        assert (blas.isILP64 == lapack.isILP64);
        [
          blas
          lapack
        ]
      )
  # KLU support is based on Suitesparse. It is tested upstream according to the
  # section 1.1.4.2 of INSTALL_GUIDE.pdf found in the source tarball.
  ++ lib.optionals kluSupport [
    suitesparse
  ];

  cmakeFlags = [
    (lib.cmakeFeature "EXAMPLES_INSTALL_PATH" "${placeholder "examples"}/share/examples")
  ]
  ++ lib.optionals lapackSupport [
    (lib.cmakeBool "ENABLE_LAPACK" true)
    (lib.cmakeFeature "LAPACK_LIBRARIES" "${lapack}/lib/liblapack${stdenv.hostPlatform.extensions.sharedLibrary}")
  ]
  ++ lib.optionals kluSupport [
    (lib.cmakeBool "ENABLE_KLU" true)
    (lib.cmakeFeature "KLU_INCLUDE_DIR" "${lib.getDev suitesparse}/include")
    (lib.cmakeFeature "KLU_LIBRARY_DIR" "${suitesparse}/lib")
  ]
  ++ [
    # Use the correct index type according to lapack and blas used. They are
    # already supposed to be compatible but we check both for extra safety. 64
    # should be the default but we prefer to be explicit, for extra safety.
    (lib.cmakeFeature "SUNDIALS_INDEX_SIZE" (toString (if blas.isILP64 then 64 else 32)))
  ];

  doCheck = true;
  checkTarget = "test";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Suite of nonlinear differential/algebraic equation solvers";
    homepage = "https://computing.llnl.gov/projects/sundials";
    downloadPage = "https://github.com/LLNL/sundials";
    changelog = "https://github.com/LLNL/sundials/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ idontgetoutmuch ];
    license = lib.licenses.bsd3;
  };
})
