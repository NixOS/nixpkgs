{ lib
, nimPackages
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "anonsurf";
  version = "3.1.7";

  src = fetchFromGitHub {
    owner = "ParrotSec";
    repo = "anonsurf";
    rev = version;
    hash = "sha256-nFgAIgDTp4ZtQON1C6Dy91dMO4ZOhg79o3rd8ccmnaI=";
  };

  nativeBuildInputs = [
    nimPackages.nim
  ];
  buildInputs = [
    nimPackages.gintro
  ];

  meta = {
    description = "Parrot anonymous mode";
    homepage = "https://github.com/ParrotSec/anonsurf";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    mainProgram = "";
    platforms = lib.platforms.all;
  };
}
