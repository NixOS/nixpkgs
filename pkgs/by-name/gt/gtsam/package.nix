{
  lib,
  stdenv,
  boost,
  cmake,
  eigen,
  fetchFromGitHub,
  metis,
  nix-update-script,
  onetbb,
  spectra,
  suitesparse,
  testers,
  withBoost ? true,
  withSuitesparse ? true,
  withTbb ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtsam";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "borglab";
    repo = "gtsam";
    tag = finalAttrs.version;
    hash = "sha256-dRX69eIZPmQ32d5k1K+JQbHv/iJ7cW6h9rUb4wUEKfk=";
  };

  postPatch = ''
    # Golden permutation captured with the bundled METIS 5.1.0; METIS 5.2.1
    # returns a different but equally valid ordering
    substituteInPlace gtsam/inference/tests/testOrdering.cpp \
      --replace-fail "EXPECT(assert_equal(expected, ordering));" ""
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    metis
    spectra
  ]
  ++ lib.optionals withSuitesparse [ suitesparse ];

  propagatedBuildInputs = [
    eigen
  ]
  ++ lib.optionals withBoost [ boost ]
  ++ lib.optionals withTbb [ onetbb ];

  cmakeFlags = [
    (lib.cmakeBool "GTSAM_USE_SYSTEM_EIGEN" true)
    (lib.cmakeBool "GTSAM_USE_SYSTEM_METIS" true)
    (lib.cmakeBool "GTSAM_USE_SYSTEM_SPECTRA" true)
    (lib.cmakeBool "GTSAM_USE_SYSTEM_CCOLAMD" withSuitesparse)
    (lib.cmakeBool "GTSAM_ENABLE_BOOST_SERIALIZATION" withBoost)
    (lib.cmakeBool "GTSAM_USE_BOOST_FEATURES" withBoost)
    (lib.cmakeBool "GTSAM_WITH_TBB" withTbb)
    (lib.cmakeBool "GTSAM_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    # Defaults to ON for 4.3.0 and trips on new compiler warnings; upstream
    # disabled it by default in https://github.com/borglab/gtsam/pull/2822
    (lib.cmakeBool "GTSAM_BUILD_WITH_WERROR" false)
    (lib.cmakeBool "GTSAM_BUILD_WITH_CCACHE" false)
    (lib.cmakeBool "GTSAM_BUILD_EXAMPLES_ALWAYS" false)
    (lib.cmakeBool "GTSAM_BUILD_TIMING_ALWAYS" false)
    (lib.cmakeBool "GTSAM_BUILD_PYTHON" false)
    (lib.cmakeBool "GTSAM_INSTALL_MATLAB_TOOLBOX" false)
  ];

  doCheck = true;
  # stdenv detects the check target with `make -n check`, which fails since
  # 4.3.0 because testValuesCrossLibrary needs a helper library that `all`
  # doesn't build; the `test` fallback doesn't build the tests
  checkTarget = "check";

  passthru = {
    tests = {
      # GTSAM_UNSTABLE is left out: its config references the `gtsam` imported
      # target without a matching find_dependency, so it only resolves after
      # GTSAM has been found and this tester checks each module on its own.
      cmake-config = testers.hasCmakeConfigModules {
        package = finalAttrs.finalPackage;
        moduleNames = [ "GTSAM" ];
        versionCheck = true;
      };
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^([0-9.]+)$"
      ];
    };
  };

  meta = {
    description = "Library for smoothing and mapping using factor graphs and Bayes networks";
    longDescription = ''
      GTSAM is a C++ library that implements smoothing and mapping (SAM) in robotics and vision, using Factor Graphs and Bayes Networks as the underlying computing paradigm rather than sparse matrices.
    '';
    homepage = "https://gtsam.org/";
    changelog = "https://github.com/borglab/gtsam/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      bsd3
      mit # bundled cephes
    ];
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.unix;
  };
})
