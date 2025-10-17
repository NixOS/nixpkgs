{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  functionalplus,
  eigen,
  nlohmann_json,
  python3Packages,
  buildTests ? false, # Needs tensorflow
  # for tests
  doctest,
  rocmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frugally-deep";
  # be careful bumping this, frugally-deep may change its model metadata format
  # in ways that only fail at runtime. MIOpen is currently the only package
  # relying on this, run passthru.tests.miopen-can-load-models to check
  version = "0.15.24-p0";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "frugally-deep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yg2SMsYOOSOgsdwIH1bU3iPM45z6c7WeIrgOddt3um4=";
  };

  patches = [
    (fetchpatch {
      # Backport CMake 4 compat so we can stay on 0.15 for now
      name = "update-minimum-cmake4-huntergate.patch";
      url = "https://github.com/Dobiasd/frugally-deep/commit/30a4ce4c932ca810a5a77c4ab943a520bb1048fe.patch";
      hash = "sha256-J5z+jQis8N2mzWu2Qm7J0fPkrplpjgDCOAJT7binz04=";
    })
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals buildTests [
    python3Packages.python
    python3Packages.numpy
  ];

  buildInputs = lib.optionals buildTests [
    doctest
    python3Packages.tensorflow
  ];

  propagatedBuildInputs = [
    functionalplus
    eigen
    nlohmann_json
  ];

  cmakeFlags = lib.optionals buildTests [ "-DFDEEP_BUILD_UNITTEST=ON" ];
  passthru.tests.miopen-can-load-models =
    rocmPackages.miopen.passthru.tests.can-load-models.override
      {
        frugally-deep = finalAttrs.finalPackage;
      };
  passthru.updateScript = gitUpdater;

  meta = with lib; {
    description = "Header-only library for using Keras (TensorFlow) models in C++";
    homepage = "https://github.com/Dobiasd/frugally-deep";
    license = with licenses; [ mit ];
    platforms = platforms.linux;
  };
})
