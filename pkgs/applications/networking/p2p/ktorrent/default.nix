{ stdenv, fetchurl, cmake
, extra-cmake-modules, qtbase, qtscript
, ki18n, kio, knotifications, knotifyconfig, kdoctools, kross, kcmutils, kdelibs4support
, libktorrent, boost, taglib, libgcrypt, kplotting
}:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "5.0.1";

  src = fetchurl {
    url = http://download.kde.org/stable/ktorrent/5.0/ktorrent-5.0.1.tar.xz;
    sha256 = "1rbr932djmn1la6vs2sy1zdf39fmla8vwzfn76h7csncbp5fw3yh";
  };

  patches =
    [ (fetchurl {
        url = https://cgit.kde.org/ktorrent.git/patch/?id=f48acc22f0105ce6bac63294d248873ae231c6cc;
        sha256 = "0jm4y35w2ypbjzf165rnjr224nq4w651ydnpd9zdn3inxh8r4s0v";
      })
    ];

  nativeBuildInputs = [ kdoctools extra-cmake-modules ];

  buildInputs =
    [ cmake qtbase qtscript
      ki18n kio knotifications knotifyconfig kross kcmutils kdelibs4support
      libktorrent taglib libgcrypt kplotting
    ];

  enableParallelBuilding = true;

  meta = {
    description = "KDE integrated BtTorrent client";
    homepage = https://www.kde.org/applications/internet/ktorrent/;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.linux;
  };
}
