{ lib, mkDerivation, fetchFromGitHub, qtbase, qttools, qmake, wrapQtAppsHook }:

mkDerivation {
  pname = "librepcb";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "56bc60d347ff67df0fe1d57807d03f0606de557f";
    sha256 = "0z6jn5zawp0x5i9zda7l787jnsv3yl8aqwnpii3g4hsnf2q3hhrh";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  buildInputs = [ qtbase ];

  qmakeFlags = ["-r"];

  postInstall = ''
      mkdir -p $out/share/librepcb/fontobene
      cp share/librepcb/fontobene/newstroke.bene $out/share/librepcb/fontobene/
    '';

  preFixup = ''
    wrapQtApp $out/bin/librepcb
  '';

  meta = with lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = https://librepcb.org/;
    maintainers = with maintainers; [ luz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
