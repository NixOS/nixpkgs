{
  cmake,
  doxygen,
  fetchFromGitHub,
  lib,
  jrl-cmakemodules,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "example-robot-data";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-robot-data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HnI1EaTSqk7mbihwFTgnMxgPZxMSYnAwaCLEXS3LUbE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  propagatedBuildInputs = [
    jrl-cmakemodules
  ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false) ];

  doCheck = true;

<<<<<<< HEAD
  meta = {
    description = "Set of robot URDFs for benchmarking and developed examples";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      nim65s
      wegank
    ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Set of robot URDFs for benchmarking and developed examples";
    homepage = "https://github.com/Gepetto/example-robot-data";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      nim65s
      wegank
    ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
})
