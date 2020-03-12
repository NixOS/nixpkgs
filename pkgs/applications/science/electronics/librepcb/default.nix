{ lib, mkDerivation, fetchFromGitHub, qtbase, qttools, qmake }:

mkDerivation {
  pname = "librepcb";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "d7458d3b3e126499902e1a66a0ef889f516a7c97";
    sha256 = "19wh0398fzzpd65nh4mmc4jllkrgcrwxvxdby0gb5wh1sqyaqac4";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  qmakeFlags = ["-r"];

  postInstall = ''
      mkdir -p $out/share/librepcb/fontobene
      cp share/librepcb/fontobene/newstroke.bene $out/share/librepcb/fontobene/
    '';

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = https://librepcb.org/;
    maintainers = with maintainers; [ luz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
