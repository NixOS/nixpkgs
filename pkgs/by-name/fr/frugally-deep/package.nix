{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  cmake,
  functionalplus,
  eigen,
  nlohmann_json,
  doctest,
  python3Packages,
  buildTests ? false, # Needs tensorflow
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frugally-deep";
  version = "0.15.24-p0";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "frugally-deep";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yg2SMsYOOSOgsdwIH1bU3iPM45z6c7WeIrgOddt3um4=";
  };

  nativeBuildInputs =
    [
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
  passthru.updateScript = gitUpdater;

  meta = with lib; {
    description = "Header-only library for using Keras (TensorFlow) models in C++";
    homepage = "https://github.com/Dobiasd/frugally-deep";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
  };
})
