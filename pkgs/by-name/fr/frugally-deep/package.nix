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
  version = "0.18.2-unstable-2025-06-16";

  src = fetchFromGitHub {
    owner = "Dobiasd";
    repo = "frugally-deep";
    rev = "30a4ce4c932ca810a5a77c4ab943a520bb1048fe";
    hash = "sha256-tcwCRSHhN61ZFDFVQ/GItvgSSjeLSbFDoNMqwswtvto=";
  };

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
  passthru.updateScript = gitUpdater;

  meta = with lib; {
    description = "Header-only library for using Keras (TensorFlow) models in C++";
    homepage = "https://github.com/Dobiasd/frugally-deep";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.linux;
  };
})
