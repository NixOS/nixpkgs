{ stdenv, fetchurl, fetchpatch, cmake
, extra-cmake-modules, qtbase, qtscript
, karchive, kcrash, kdnssd, ki18n, kio, knotifications, knotifyconfig
, kdoctools, kross, kcmutils, kwindowsystem
, libktorrent, taglib, libgcrypt, kplotting
}:

stdenv.mkDerivation rec {
  pname = "ktorrent";
  version = "${libktorrent.mainVersion}";

  src = fetchurl {
    url    = "mirror://kde/stable/ktorrent/${libktorrent.mainVersion}/${pname}-${version}.tar.xz";
    sha256 = "0kwd0npxfg4mdh7f3xadd2zjlqalpb1jxk61505qpcgcssijf534";
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
