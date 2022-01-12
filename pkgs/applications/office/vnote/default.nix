{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qtwebengine
}:

mkDerivation rec {
  pname = "vnote";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-JZqV+ZDYRWiuKLSctB2L2SGPmboLeL3HeecMoaNXY+4=";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    qtbase
    qtwebengine
  ];

  meta = with lib; {
    homepage = "https://vnotex.github.io/vnote";
    description = "A pleasant note-taking platform";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
