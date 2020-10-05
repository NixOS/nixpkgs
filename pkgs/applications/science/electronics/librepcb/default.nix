{ lib, mkDerivation, fetchFromGitHub, qtbase, qttools, qmake, wrapQtAppsHook }:

mkDerivation rec {
  pname = "librepcb";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = version;
    sha256 = "0ag8h3id2c1k9ds22rfrvyhf2vjhkv82xnrdrz4n1hnlr9566vcx";
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
    homepage = "https://librepcb.org/";
    maintainers = with maintainers; [ luz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
