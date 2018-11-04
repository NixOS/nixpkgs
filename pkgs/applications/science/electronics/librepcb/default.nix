{ stdenv, fetchFromGitHub, qtbase, qttools, qmake }:

stdenv.mkDerivation rec {
  name = "librepcb-${version}";
  version = "20181031";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "3cf8dba9fa88e5b392d639c9fdbcf3a44664170a";
    sha256 = "0kr4mii5w3kj3kqvhgq7zjxjrq44scx8ky0x77gyqmwvwfwk7nmx";
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
