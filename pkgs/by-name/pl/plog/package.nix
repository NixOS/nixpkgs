{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "plog";
  version = "1.1.10";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "SergiusTheBest";
    repo = pname;
    rev = version;
    hash = "sha256-NZphrg9OB1FTY2ifu76AXeCyGwW2a2BkxMGjZPf4uM8=";
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
}
