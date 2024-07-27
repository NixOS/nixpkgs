{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  bison,
  boost,
  capnproto,
  doxygen,
  flex,
  libdwarf-lite,
  pkg-config,
  python3,
  tbb_2021_11,
}:
stdenv.mkDerivation {
  pname = "naja";
  version = "0-unstable-2024-07-21";

  src = fetchFromGitHub {
    owner = "najaeda";
    repo = "naja";
    rev = "8c068f3bd1bbd57b851547f191a58a375fd35cda";
    hash = "sha256-aUYPJGr4D5n92fp0namPT6I/gMRZoF7YHnB7GoRzwYI=";
    fetchSubmodules = true;
  };

  outputs = [
    "dev"
    "lib"
    "out"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    bison
    capnproto
    cmake
    doxygen
    flex
    pkg-config
    python3
  ];

  buildInputs = [
    boost
    capnproto # cmake modules
    flex # include dir
    libdwarf-lite
    tbb_2021_11
  ];

  cmakeFlags = [
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_LIBDWARF" true)
    (lib.cmakeBool "CPPTRACE_USE_EXTERNAL_ZSTD" true)
  ];

  doCheck = true;

  meta = {
    description = "Structural Netlist API (and more) for EDA post synthesis flow development";
    homepage = "https://github.com/najaeda/naja";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "naja_edit";
    platforms = lib.platforms.all;
  };
}
