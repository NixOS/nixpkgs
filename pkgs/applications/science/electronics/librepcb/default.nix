{ stdenv, fetchFromGitHub, qtbase, qttools, qmake, libGLU_combined, openssl, zlib }:

stdenv.mkDerivation rec {
  name = "librepcb-${version}";
  version = "20171229";

  src = fetchFromGitHub {
    owner = "LibrePCB";
    repo = "LibrePCB";
    fetchSubmodules = true;
    rev = "4efb06fa42755abc5e606da4669cc17e8de2f8c6";
    sha256 = "0r33fm1djqpy0dzvnf5gv2dfh5nj2acaxb7w4cn8yxdgrazjf7ak";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ qtbase ];

	# LibrePCB still supports QT below 5.9. But some code lines break the build, so they are removed by this patch so that the software builds.
  patches = [ ./fix-2017-12.patch ];

  qmakeFlags = ["-r"];

  meta = with stdenv.lib; {
    description = "A free EDA software to develop printed circuit boards";
    homepage = http://librepcb.org/;
    maintainers = with maintainers; [ luz ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
