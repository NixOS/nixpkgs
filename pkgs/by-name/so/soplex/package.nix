{ lib
, stdenv
, cmake
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "soplex";
  version = "6.0.4";

  src = fetchFromGitHub {
    owner = "scipopt";
    repo = "soplex";
    rev = "release-604";
    hash = "sha256-miTgfouMk+TofHO6aJVY6op9JM5k1ekLkkGAfu3QVsM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  doCheck = true;

  meta = with lib; {
    description = "Sequential object-oriented simPlex";
    homepage = "https://scipopt.org";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ david-r-cox ];
    mainProgram = "soplex";
  };
}
