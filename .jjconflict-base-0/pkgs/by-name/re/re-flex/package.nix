{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "re-flex";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Genivia";
    repo = "RE-flex";
    rev = "v${version}";
    hash = "sha256-w3qL02I9nrOkEFqmMQU4noPRCamyvJTYpQJYJiUf4ec=";
  };

  outputs = [ "out" "bin" "dev" ];

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://www.genivia.com/doc/reflex/html";
    description = "Regex-centric, fast lexical analyzer generator for C++ with full Unicode support";
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with lib.maintainers; [ prrlvr ];
    mainProgram = "reflex";
  };
}
