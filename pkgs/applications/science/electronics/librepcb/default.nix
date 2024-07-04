{ stdenv, lib, fetchFromGitHub
, qtbase, qttools, qtquickcontrols2, opencascade-occt, libGLU, cmake, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = version;
    sha256 = "sha256-Vyp7asVqvKFkkEb67LXapMkT1AQSburN3+B2dXIPcEU=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qttools wrapQtAppsHook qtquickcontrols2 opencascade-occt libGLU ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "Free EDA software to develop printed circuit boards";
    homepage    = "https://librepcb.org/";
    maintainers = with maintainers; [ luz thoughtpolice ];
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
