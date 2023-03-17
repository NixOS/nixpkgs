{ stdenv, lib, fetchFromGitHub
, qtbase, qttools, cmake, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = version;
    sha256 = "sha256-zqvvc3CHqdRWVUFt4BkH5Vq50/FKNvMNW2NvGyfWwFM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake qttools wrapQtAppsHook ];
  buildInputs = [ qtbase ];

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage    = "https://librepcb.org/";
    maintainers = with maintainers; [ luz thoughtpolice ];
    license     = licenses.gpl3Plus;
    platforms   = platforms.linux;
  };
}
