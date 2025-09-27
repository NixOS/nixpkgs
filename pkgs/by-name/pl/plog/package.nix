{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "plog";
  version = "1.1.11";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "SergiusTheBest";
    repo = "plog";
    rev = version;
    hash = "sha256-/H7qNL6aPjmFYk0X1sx4CCSZWrAMQgPo8I9X/P50ln0=";
  };

  strictDeps = true;
  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DPLOG_BUILD_SAMPLES=NO"
  ];

  meta = with lib; {
    description = "Portable, simple and extensible C++ logging library";
    homepage = "https://github.com/SergiusTheBest/plog";
    license = licenses.mit;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [
      raphaelr
      erdnaxe
    ];
  };
}
