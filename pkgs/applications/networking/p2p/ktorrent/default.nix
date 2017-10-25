{ stdenv, fetchurl, cmake
, extra-cmake-modules, qtbase, qtscript
, karchive, kcrash, kdnssd, ki18n, kio, knotifications, knotifyconfig
, kdoctools, kross, kcmutils, kwindowsystem
, libktorrent, boost, taglib, libgcrypt, kplotting
}:

stdenv.mkDerivation rec {
  name = "ktorrent-${version}";
  version = "${libktorrent.mainVersion}.0";

  src = fetchurl {
    url    = "mirror://kde/stable/ktorrent/${libktorrent.mainVersion}/${name}.tar.xz";
    sha256 = "18w6qh09k84qpzaxxb76a4g59k4mx5wk897vqp1wwv80g0pqhmrw";
  };

  nativeBuildInputs = [ cmake kdoctools extra-cmake-modules ];

  buildInputs = [
    qtbase qtscript
    karchive kcrash kdnssd ki18n kio knotifications knotifyconfig kross kcmutils kwindowsystem
    libktorrent taglib libgcrypt kplotting
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "KDE integrated BtTorrent client";
    homepage    = https://www.kde.org/applications/internet/ktorrent/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ eelco ];
    platforms   = platforms.linux;
  };
}
