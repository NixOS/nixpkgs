{
  fetchFromGitHub,
  lib,
  stdenv,
  cmake,
  fmt,
  spdlog,
  tl-expected,
  nlohmann_json,
  yaml-cpp,
  simdjson,
  reproc,
  libsolv,
  curl,
  libarchive,
  zstd,
  bzip2,
  python3Packages,
}:
stdenv.mkDerivation rec {
  pname = "libmamba";
  version = "1.5.7";
  src = fetchFromGitHub {
    owner = "mamba-org";
    repo = "mamba";
    rev = "${pname}-${version}";
    hash = "sha256-HfmvLi9IBWlaGAn2Ej4Bnm4b3l19jEXwNl5IUkdVxi0=";
  };
  nativeBuildInputs = [
    cmake
    python3Packages.python
  ];
  buildInputs = [
    fmt
    spdlog
    tl-expected
    nlohmann_json
    yaml-cpp
    simdjson
    reproc
    libsolv
    curl
    libarchive
    zstd
    bzip2
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_LIBMAMBA" true)
    (lib.cmakeBool "BUILD_SHARED" true)
  ];

  meta = {
    description = "The library for the fast Cross-Platform Package Manager";
    homepage = "https://github.com/mamba-org/mamba";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.ericthemagician ];
  };
}
