{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "marl";
  version = "1.0.0"; # Based on marl's CHANGES.md

  src = fetchFromGitHub {
    owner = "google";
    repo = "marl";
    hash = "sha256-PBQOcT67LNqa/nal8i67sP3+9qhCezVZAVCg7VdWy14=";
    rev = "40209e952f5c1f3bc883d2b7f53b274bd454ca53";
  };

  nativeBuildInputs = [ cmake ];

  # Turn on the flag to install after building the library.
  cmakeFlags = [ "-DMARL_INSTALL=ON" ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "https://github.com/google/marl";
    description = "Hybrid thread / fiber task scheduler written in C++ 11";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ breakds ];
  };
}
