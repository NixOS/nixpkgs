{ callPackage, stdenv, lib
, fetchFromGitHub
, boost, immer, zug
, pkg-config, cmake
}:

stdenv.mkDerivation rec {
  pname = "lager";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-KTHrVV/186l4klwlcfDwFsKVoOVqWCUPzHnIbWuatbg=";
  };
  buildInputs = [
    boost
    immer
    zug
  ];
  nativeBuildInputs = [
    cmake
  ];
  cmakeFlags = [
    "-Dlager_BUILD_TESTS=OFF"
    "-Dlager_BUILD_EXAMPLES=OFF"
  ];
  meta = with lib; {
    homepage    = "https://github.com/arximboldi/lager";
    description = "library for functional interactive c++ programs";
    license     = licenses.mit;
    maintainers = with maintainers; [ nek0 ];
  };
}
