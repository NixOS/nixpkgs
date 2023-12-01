{ stdenv, lib, fetchFromGitHub
, qtbase, qttools, qtquickcontrols2, opencascade-occt, libGLU, libSM, freeimage, cmake, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = version;
    sha256 = "sha256-2o2Gue/RnDWxe8jk/Ehx9CM+B3ac5rEQn0H7yodUEZ8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qttools wrapQtAppsHook qtquickcontrols2 opencascade-occt libGLU ];
  buildInputs = [ qtbase ];
  propagatedBuildInputs = [ libSM freeimage ];

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage    = "https://librepcb.org/";
    maintainers = with maintainers; [ luz thoughtpolice ];
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
