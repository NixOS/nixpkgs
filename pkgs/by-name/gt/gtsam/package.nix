{
  lib,
  stdenv,
  boost,
  cmake,
  eigen,
  fetchFromGitHub,
  nix-update-script,
  onetbb,
  testers,
  runTests ? false,
  withTbb ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gtsam";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "borglab";
    repo = "gtsam";
    tag = finalAttrs.version;
    hash = "sha256-7qYwPDSPvqiDBD9PFGOn+S9NkvfGbHuFIhQ3NN1WwLo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];

  propagatedBuildInputs = [
    boost
    eigen
  ]
  ++ lib.optionals withTbb [ onetbb ];

  cmakeFlags = [
    # TODO: enable GTSAM_USE_SYSTEM_SPECTRA after https://github.com/borglab/gtsam/pull/2632 lands

    # TODO: remove after 4.3+; 4.2.2 declares cmake_minimum_required(VERSION 3.0)
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5")

    (lib.cmakeBool "GTSAM_USE_SYSTEM_EIGEN" true)
    (lib.cmakeBool "GTSAM_USE_SYSTEM_METIS" false) # TODO: flip this after https://github.com/borglab/gtsam/pull/2631 lands
    (lib.cmakeBool "GTSAM_WITH_TBB" withTbb)
    (lib.cmakeBool "GTSAM_BUILD_TESTS" runTests)
    (lib.cmakeBool "GTSAM_BUILD_WITH_CCACHE" false)
    (lib.cmakeBool "GTSAM_BUILD_EXAMPLES_ALWAYS" false)
    (lib.cmakeBool "GTSAM_BUILD_TIMING_ALWAYS" false)
    (lib.cmakeBool "GTSAM_BUILD_PYTHON" false)
    (lib.cmakeBool "GTSAM_INSTALL_MATLAB_TOOLBOX" false)
  ];

  doCheck = runTests;

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
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ilkecan ];
    platforms = lib.platforms.unix;
  };
})
