{ stdenv
, fetchurl
, cmake
, qtbase
, qtsvg
, qtmultimedia
, qttools
, kdnssd
, karchive
, libsodium
, libmicrohttpd
, giflib
, miniupnpc
}:

stdenv.mkDerivation rec {
  name = "drawpile-${version}";
  version = "2.0.11";
  src = fetchurl {
    url = "https://drawpile.net/files/src/drawpile-${version}.tar.gz";
    sha256 = "0h018rxhc0lwpqwmlihalz634nd0xaafk4p2b782djjd87irnjpk";
  };
  buildInputs = [
    cmake
    qtbase qtsvg qtmultimedia qttools
    karchive
    # optional deps:
    libsodium # ext-auth support
    libmicrohttpd # HTTP admin api
    giflib # gif animation export support
    miniupnpc # automatic port forwarding
    kdnssd # local server discovery with Zeroconf
  ];
  configurePhase = "cmake -DCMAKE_INSTALL_PREFIX=$out .";

  meta = with stdenv.lib; {
    description = "A collaborative drawing program that allows multiple users to sketch on the same canvas simultaneously";
    homepage = https://drawpile.net/;
    downloadPage = https://drawpile.net/download/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
  };
}

