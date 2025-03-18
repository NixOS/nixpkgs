{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, immer
, zug
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lager";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "arximboldi";
    repo = "lager";
    rev = "v${finalAttrs.version}";
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
    "-Dlager_BUILD_EXAMPLES=OFF"
  ];

  meta = {
    homepage = "https://github.com/arximboldi/lager";
    description = "C++ library for value-oriented design using the unidirectional data-flow architecture — Redux for C++";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nek0 ];
  };
})
