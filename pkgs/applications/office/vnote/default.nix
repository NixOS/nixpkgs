{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, qtbase
, qtwebengine
}:

mkDerivation rec {
  pname = "vnote";
  version = "3.8.1";

  src = fetchFromGitHub {
    owner = "vnotex";
    repo = pname;
    fetchSubmodules = true;
    rev = "v${version}";
    sha256 = "sha256-GgSVBVcT0rfgglyjCmkEMbKCEltesC3eSsN38psrkS4=";
  };

  nativeBuildInputs = [ qmake ];
  buildInputs = [ qtbase qtwebengine ];

  meta = with lib; {
    homepage = "https://vnotex.github.io/vnote";
    description = "A pleasant note-taking platform";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
