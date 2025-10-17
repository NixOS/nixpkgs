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

  meta = with lib; {
    description = "C++11 Lightweight Redis client: async, thread-safe, no dependency, pipelining, multi-platform";
    homepage = "https://github.com/cpp-redis/cpp_redis";
    changelog = "https://github.com/cpp-redis/cpp_redis/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ poelzi ];
    platforms = platforms.all;
  };
}
