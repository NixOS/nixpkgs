{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, capnproto
, gtest
}:

stdenv.mkDerivation rec {
  pname = "UHDM";
  version = "1.57";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z3vURlKXCW5W2naVwJjBXcn94u80JsBxlUOIy9ylsJw=";
  };

  nativeBuildInputs = [
    cmake
    (python3.withPackages (p: with p; [ orderedmultidict ]))
    gtest
  ];

  buildInputs = [
    capnproto
  ];

  cmakeFlags = [
    "-DUHDM_USE_HOST_GTEST=On"
    "-DUHDM_USE_HOST_CAPNP=On"
  ];

  doCheck = true;
  checkPhase = "make test";

  meta = {
    description = "Universal Hardware Data Model";
    homepage = "https://github.com/chipsalliance/UHDM";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.all;
  };
}
