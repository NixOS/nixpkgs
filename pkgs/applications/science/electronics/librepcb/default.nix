{ stdenv, fetchgit, qtbase, qttools, qmake, mesa, openssl, zlib }:

stdenv.mkDerivation rec {
	name = "librepcb-unstable";
	version = "2017-12-29";
	src = fetchgit {
		url = "git://github.com/LibrePCB/LibrePCB";
		rev = "4efb06fa42755abc5e606da4669cc17e8de2f8c6";
		sha256 = "0r33fm1djqpy0dzvnf5gv2dfh5nj2acaxb7w4cn8yxdgrazjf7ak";
	};

	enableParallelBuilding=true;

	nativeBuildInputs = [ qmake qttools qtbase ];

	patches = [ ./fix-2017-12.patch ];

	#recursive qmake building is required -> therefore this line is required (qmake -r)
	preBuild = "mkdir build && cd build && qmake -r ../librepcb.pro PREFIX=$out QMAKE_LRELEASE=${stdenv.lib.getDev qttools.dev}/bin/lrelease";

	meta = with stdenv.lib; {
		description = "A free EDA software to develop printed circuit boards";
		homepage = http://librepcb.org/;
		maintainers = with maintainers; [ luz ];
		license = licenses.gpl3;
		platforms = platforms.linux;
	};
}

