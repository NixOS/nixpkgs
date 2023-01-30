/*
FIXME

find_package(flashlight REQUIRED)
if (flashlight_FOUND)
  message(STATUS "flashlight found (include: ${FLASHLIGHT_INCLUDE_DIRS} lib: flashlight::flashlight )")
  if (NOT TARGET flashlight::Distributed)
    message(FATAL_ERROR "flashlight must be build in distributed mode for wav2letter++")

-> try a newer version of wav2letter?

*/

{ lib
, stdenv
, fetchFromGitHub
, cmake
, arrayfire
, glog
, flashlight_0_3
}:

stdenv.mkDerivation rec {
  pname = "wav2letter";
  version = "0.2-unstable-2022-12-03";

  src = fetchFromGitHub {
    owner = "flashlight";
    repo = "wav2letter";
    # this breaks because of a bug in fetchurl https://github.com/NixOS/nixpkgs/issues/213560
    #rev = "v${version}";
    rev = "93bffaef9caa9c8711ff383c1fce338e5cb5a506";
    sha256 = "sha256-FRWGBRKvhPr59An1L/H5gQjhYLn6b5iiTMuBMW2TLUI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    arrayfire
    glog
    # Use Flashlight's 0.3 branch
    # https://github.com/flashlight/wav2letter/blob/93bffaef9caa9c8711ff383c1fce338e5cb5a506/CMakeLists.txt#L12
    # flashlight must be build in distributed mode for wav2letter++
    flashlight_0_3
  ];

  meta = {
    homepage = "https://github.com/flashlight/wav2letter";
    description = "Facebook AI Research's Automatic Speech Recognition Toolkit";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
