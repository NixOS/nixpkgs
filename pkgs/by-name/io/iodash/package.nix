{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
}:

stdenv.mkDerivation {
  pname = "iodash";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "YukiWorkshop";
    repo = "IODash";
    rev = "9dcb26621a9c17dbab704b5bab0c3a5fc72624cb";
    hash = "sha256-fZ3rcITmN0XzfoWFejuoNppTh4epyn8DHJA7A4TwZTU=";
    fetchSubmodules = true;
  };
  # adds missing cmake install directives
  # https://github.com/YukiWorkshop/IODash/pull/2
  patches = [ ./0001-Add-cmake-install-directives.patch ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = {
    homepage = "https://github.com/YukiWorkshop/IODash";
    description = "Lightweight C++ I/O library for POSIX operation systems";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jappie ];
    platforms = with lib.platforms; linux;
  };
}
