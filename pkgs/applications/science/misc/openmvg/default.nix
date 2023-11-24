{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, cereal, openmp
, libjpeg ? null
, zlib ? null
, libpng ? null
, eigen ? null
, libtiff ? null
, ceres-solver
, enableShared ? !stdenv.hostPlatform.isStatic
, enableExamples ? false
, enableDocs ? false }:

stdenv.mkDerivation rec {
  version = "unstable-2022-12-30";
  pname = "openmvg";

  src = fetchFromGitHub {
    owner = "openmvg";
    repo = "openmvg";
    rev = "e1bbfe801986cd7171f36443a1573b0f69f3702d";
    sha256 = "sha256-DngfmejNFw5pogTo7Ec5aUey2LUQIojvJybLmtCfvVY=";
    fetchSubmodules = true;
  };

  buildInputs = [ libjpeg zlib libpng eigen libtiff cereal openmp ceres-solver ];

  nativeBuildInputs = [ cmake pkg-config ];

  cmakeFlags = [
    "-DOpenMVG_BUILD_EXAMPLES=${if enableExamples then "ON" else "OFF"}"
    "-DOpenMVG_BUILD_DOC=${if enableDocs then "ON" else "OFF"}"
    "-DTARGET_ARCHITECTURE=generic"
  ] ++ lib.optional enableShared "-DOpenMVG_BUILD_SHARED=ON";

  cmakeDir = "./src";

  dontUseCmakeBuildDir = true;

  # This can be enabled, but it will exhause virtual memory on most machines.
  enableParallelBuilding = false;

  # Without hardeningDisable, certain flags are passed to the compile that break the build (primarily string format errors)
  hardeningDisable = [ "all" ];

  meta = {
    broken = stdenv.isDarwin && stdenv.isx86_64;
    description = "A library for computer-vision scientists and targeted for the Multiple View Geometry community";
    homepage = "https://openmvg.readthedocs.io/en/latest/";
    license = lib.licenses.mpl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ mdaiter bouk ];
  };
}
