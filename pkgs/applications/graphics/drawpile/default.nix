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
, extra-cmake-modules
, libvpx
}:

stdenv.mkDerivation rec {
  name = "drawpile-${version}";
  version = "2.1.3";
  src = fetchurl {
    url = "https://drawpile.net/files/src/drawpile-${version}.tar.gz";
    sha256 = "0fngj5hfinj66xpij2h3ag79mgmqcfrjpwynxdbjr5brch25ldwj";
  };
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    # common deps:
    cmake
    qtbase qtsvg qtmultimedia qttools
    karchive
    # optional deps:
    #   server-specific:
    libsodium # ext-auth support
    libmicrohttpd # HTTP admin api
    #   client-specific:
    giflib # gif animation export support
    miniupnpc # automatic port forwarding
    kdnssd # local server discovery with Zeroconf
    libvpx # WebM video export
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

