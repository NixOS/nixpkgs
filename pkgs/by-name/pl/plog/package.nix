{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plog";
  version = "1.1.11";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "SergiusTheBest";
    repo = "plog";
    rev = finalAttrs.version;
    hash = "sha256-/H7qNL6aPjmFYk0X1sx4CCSZWrAMQgPo8I9X/P50ln0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DPLOG_BUILD_SAMPLES=NO"
  ];

  meta = {
    description = "Portable, simple and extensible C++ logging library";
    homepage = "https://github.com/SergiusTheBest/plog";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      raphaelr
      erdnaxe
    ];
  };
})
