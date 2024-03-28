{ lib
, stdenv
, fetchFromGitHub
, cmake
, meson
}:

stdenv.mkDerivation rec {
  pname = "etl";
  version = "20.38.6";

  src = fetchFromGitHub {
    owner = "ETLCPP";
    repo = "etl";
    rev = version;
    hash = "sha256-2XhtSloxjL90zKH54WjBURHKCQnSPbJOAxi3WFqIGZE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    meson
  ];

  meta = with lib; {
    description = "Embedded Template Library";
    homepage = "https://github.com/ETLCPP/etl.git";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
    platforms = platforms.all;
  };
}
