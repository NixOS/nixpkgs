{
  cmake,
  fetchFromGitHub,
  lib,
  libxml2,
  pcre,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation {
  pname = "opencollada";
  version = "0-unstable-2025-01-30";

  src = fetchFromGitHub {
    owner = "aras-p";
    repo = "OpenCOLLADA";
    rev = "4526eb8aaa6462c71fbedd23103976c151a01c50";
    sha256 = "sha256-ctr+GjDzxOJxBfaMwjwayPkAOcF+FMsP1X72QCOwvTY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  propagatedBuildInputs = [
    libxml2
    pcre
  ];

  meta = {
    description = "Library for handling the COLLADA file format";
    homepage = "https://github.com/KhronosGroup/OpenCOLLADA/";
    maintainers = [ lib.maintainers.amarshall ];
    platforms = lib.platforms.unix;
    license = lib.licenses.mit;
  };
}
