{
  lib,
  boost,
  ceres-solver,
  cmake,
  cminpack,
  dlib,
  fetchFromGitHub,
  hdf5,
  hmat-oss,
  ipopt,
  libxml2,
  nlopt,
  pagmo2,
  primesieve,
  python3Packages,
  spectra,
  stdenv,
  swig,
  tbb,
  # Boolean flags
  runTests ? false, # tests take an hour to build on a 48-core machine
  enablePython ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openturns";
  version = "1.25.1";

  src = fetchFromGitHub {
    owner = "openturns";
    repo = "openturns";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TwM6RvXG4+IBNxH2Ajg9atcaOGlC4kzusH8+6VbI6m4=";
  };

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals enablePython [ python3Packages.sphinx ];

  buildInputs = [
    (lib.getLib primesieve)
    boost
    ceres-solver
    cminpack
    dlib
    hdf5
    hmat-oss
    ipopt
    libxml2
    nlopt
    pagmo2
    spectra
    swig
    tbb
  ]
  ++ lib.optionals enablePython [
    python3Packages.dill
    python3Packages.matplotlib
    python3Packages.psutil
    python3Packages.python
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON" enablePython)
    (lib.cmakeBool "CMAKE_UNITY_BUILD" true)
    (lib.cmakeBool "USE_SPHINX" enablePython)
    (lib.cmakeFeature "CMAKE_UNITY_BUILD_BATCH_SIZE" "32")
    (lib.cmakeFeature "SWIG_COMPILE_FLAGS" "-O1")
    (lib.cmakeOptionType "PATH" "OPENTURNS_SYSCONFIG_PATH" "${placeholder "out"}/etc")
  ];

  checkTarget = lib.concatStringsSep " " [
    "tests"
    "check"
  ];

  strictDeps = true;

  doCheck = runTests;

  meta = {
    homepage = "https://openturns.github.io/www/";
    description = "Multivariate probabilistic modeling and uncertainty treatment library";
    changelog = "https://github.com/openturns/openturns/raw/v${finalAttrs.version}/ChangeLog";
    license = with lib.licenses; [
      lgpl3Plus
      gpl3Plus
    ];
    maintainers = with lib.maintainers; [ gdinh ];
    platforms = lib.platforms.unix;
  };
})
