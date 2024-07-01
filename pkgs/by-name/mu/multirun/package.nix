{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "multirun";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "nicolas-van";
    repo = "multirun";
    rev = version;
    hash = "sha256-I95nxZD65tHiok4MzsGG7gyaxPHbqQLuRWdHUPNhLu8=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Minimalist init process designed for Docker";
    homepage = "https://github.com/nicolas-van/multirun";
    license = licenses.mit;
    maintainers = with maintainers; [ nickcao ];
    mainProgram = "multirun";
    platforms = platforms.all;
  };
}
