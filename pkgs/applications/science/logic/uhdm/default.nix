{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, capnproto
, gtest
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "UHDM";
  version = "1.73";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-VmRn51UrJTGEG4n2fi5kRv8khXakfGbqMtYPejsZCBI=";
    fetchSubmodules = false;  # we use all dependencies from nix
=======
stdenv.mkDerivation rec {
  pname = "UHDM";
  version = "1.57";

  src = fetchFromGitHub {
    owner = "chipsalliance";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-z3vURlKXCW5W2naVwJjBXcn94u80JsBxlUOIy9ylsJw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
})
=======
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
