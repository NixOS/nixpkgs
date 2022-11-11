{ lib, stdenv
, fetchFromGitHub
, cmake
, clingo
, catch2
}:

stdenv.mkDerivation rec {
  pname = "clingcon";
  version = "5.2.0";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-wZfTneoQSqEnLAVE8WyPh9EABmOEhDgRm6yWAF1T7Nk=";
   };

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp libclingcon/tests/catch.hpp
  '';

  nativeBuildInputs = [ cmake clingo ];

  cmakeFlags = [
    "-DCLINGCON_MANAGE_RPATH=ON"
    "-DPYCLINGCON_ENABLE=OFF"
    "-DCLINGCON_BUILD_TESTS=ON"
  ];

  doCheck = true;

  meta = {
    description = "Extension of clingo to handle constraints over integers";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingcon/releases/";
    changelog = "https://github.com/potassco/clingcon/releases/tag/v${version}";
  };
}
