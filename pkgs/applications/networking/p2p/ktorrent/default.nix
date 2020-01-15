{ stdenv, fetchurl, fetchpatch, cmake
, extra-cmake-modules, qtbase, qtscript
, karchive, kcrash, kdnssd, ki18n, kio, knotifications, knotifyconfig
, kdoctools, kross, kcmutils, kwindowsystem
, libktorrent, taglib, libgcrypt, kplotting
}:

stdenv.mkDerivation rec {
  pname = "ktorrent";
  version = "${libktorrent.mainVersion}.0";

  src = fetchurl {
    url    = "mirror://kde/stable/ktorrent/${libktorrent.mainVersion}/${pname}-${version}.tar.xz";
    sha256 = "18w6qh09k84qpzaxxb76a4g59k4mx5wk897vqp1wwv80g0pqhmrw";
  };

  nativeBuildInputs = [ cmake kdoctools extra-cmake-modules ];

  buildInputs = [
    qtbase qtscript
    karchive kcrash kdnssd ki18n kio knotifications knotifyconfig kross kcmutils kwindowsystem
    libktorrent taglib libgcrypt kplotting
  ];

  patches = [
    # Fix build with CMake 3.11
    (fetchpatch {
      url = "https://cgit.kde.org/ktorrent.git/patch/?id=672c5076de7e3a526d9bdbb484a69e9386bc49f8";
      sha256 = "1cn4rnbhadrsxqx50fawpd747azskavbjraygr6s11rh1wbfrxid";
    })

    # Fix build against Qt 5.11
    (fetchpatch {
      url = "https://cgit.kde.org/ktorrent.git/patch/?id=7876857d204188016a135a25938d9f8530fba4e8";
      sha256 = "1wnmfzkhf6y7fd0z2djwphs6i9lsg7fcrj8fqmbyi0j57dvl9gxl";
    })
    (fetchpatch {
      url = "https://cgit.kde.org/ktorrent.git/patch/?id=36d112e56e56541d439326a267eb906da8b3ee60";
      sha256 = "1d41pqniljhwqs6awa644s6ks0zwm9sr0hpfygc63wyxnpcrsw2y";
    })
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
