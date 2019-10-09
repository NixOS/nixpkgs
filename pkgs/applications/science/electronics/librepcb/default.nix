{ stdenv, fetchFromGitHub, qtbase, qttools, qmake, wrapQtAppsHook }:

stdenv.mkDerivation {
  pname = "librepcb";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "acdd94d9d2310f79215125b999153e9da88a9376";
    sha256 = "1bbl01rp75sl6k1cmch7x90v00lck578xvqmb856s9fx75bdgnv5";
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

  meta = with stdenv.lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = https://librepcb.org/;
    maintainers = with maintainers; [ luz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
