{ lib, mkDerivation, fetchFromGitHub, qtbase, qttools, qmake, wrapQtAppsHook }:

mkDerivation {
  pname = "librepcb";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "ae04eef5a71b5ba66ae2cee6b631c1c933ace535";
    sha256 = "0wk5qny1jb6n4mwyyrs7syir3hmwxlwazcd80bpxharmsj7p0rzc";
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
