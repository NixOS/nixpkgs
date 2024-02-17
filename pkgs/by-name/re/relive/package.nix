{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "relive";
  version = "unstable-2023-12-24";

  src = fetchFromGitHub {
    owner = "AliveTeam";
    repo = "alive_reversing";
    rev = "f651f1595d5dd05bc5a5d94ef1b5b9753262d8eb";
    hash = "sha256-4dZ4efxqdK/MJauQwQVBiz/AeqeCnEDNYwOKbDzU1gY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Re-implementation of Oddworld: Abe's Exoddus and Oddworld: Abe's Oddysee";
    homepage = "https://github.com/AliveTeam/alive_reversing";
    license = licenses.unfree;
    maintainers = with maintainers; [ iogamaster ];
    mainProgram = "relive";
    platforms = platforms.all;
  };
}
