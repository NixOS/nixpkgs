{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "cpp-redis";
  version = "4.3.1";

  src = fetchFromGitHub {
    owner = "cpp-redis";
    repo = "cpp_redis";
    tag = version;
    hash = "sha256-dLAnxgldylWWKO3WIyx+F7ylOpRH+0nD7NZjWSOxuwQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  CFLAGS = "-D_GLIBCXX_USE_NANOSLEEP";
  patches = [
    ./01-fix-sleep_for.patch
  ];

  # CMake 2.8.7 is deprecated and is no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt tacopie/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8.7)" \
      "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    description = "C++11 Lightweight Redis client: async, thread-safe, no dependency, pipelining, multi-platform";
    homepage = "https://github.com/cpp-redis/cpp_redis";
    changelog = "https://github.com/cpp-redis/cpp_redis/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ poelzi ];
    platforms = platforms.all;
  };
}
