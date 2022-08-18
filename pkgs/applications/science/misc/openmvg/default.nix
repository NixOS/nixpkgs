{ lib, stdenv, fetchFromGitHub, pkg-config, cmake
, libjpeg ? null
, zlib ? null
, libpng ? null
, eigen ? null
, libtiff ? null
, enableExamples ? false
, enableDocs ? false }:

stdenv.mkDerivation rec {
  version = "2.0";
  pname = "openmvg";

  src = fetchFromGitHub {
    owner = "openmvg";
    repo = "openmvg";
    rev = "v${version}";
    sha256 = "sha256-6F/xUgZpqY+v6CpwTBhIXI4JdT8HVB0P5JzOL66AVd8=";
    fetchSubmodules = true;
  };

  buildInputs = [ libjpeg zlib libpng eigen libtiff ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-std=c++11"
    "-DOpenMVG_BUILD_EXAMPLES=${lib.boolToCMakeString enableExamples}"
    "-DOpenMVG_BUILD_DOC=${lib.boolToCMakeString enableDocs}"
  ];

  cmakeDir = "./src";

  dontUseCmakeBuildDir = true;

  # This can be enabled, but it will exhause virtual memory on most machines.
  enableParallelBuilding = false;

  # Without hardeningDisable, certain flags are passed to the compile that break the build (primarily string format errors)
  hardeningDisable = [ "all" ];

  meta = {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A library for computer-vision scientists and targeted for the Multiple View Geometry community";
    homepage = "https://openmvg.readthedocs.io/en/latest/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mdaiter ];
  };
}
