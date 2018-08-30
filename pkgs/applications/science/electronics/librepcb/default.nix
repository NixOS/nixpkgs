{ stdenv, fetchFromGitHub, qtbase, qttools, qmake }:

stdenv.mkDerivation rec {
  name = "librepcb-${version}";
  version = "20180628";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "68577ecf8f39299ef4d81ff964b01c3908d1f10b";
    sha256 = "1ca4q8b8fhp19vq5yi55sq6xlsz14ihw3i0h7rq5fw0kigpjldmz";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

  qmakeFlags = ["-r"];

  postInstall = ''
      mkdir -p $out/share/librepcb/fontobene
      cp share/librepcb/fontobene/newstroke.bene $out/share/librepcb/fontobene/
    '';

  meta = with stdenv.lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = http://librepcb.org/;
    maintainers = with maintainers; [ luz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
