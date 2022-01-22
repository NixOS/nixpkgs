{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qtwebengine
}:

mkDerivation rec {
  pname = "vnote";
  version = "3.12.0";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-hlB/G7qFYbkdIk9f2N+q1Do3V1ON8UUQZ6AUmBfK8x0=";
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
