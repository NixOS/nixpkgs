{ lib
, stdenv
, fetchurl
, python3
, makeWrapper
, libtorrent-rasterbar-1_2_x
, qt5
}:

let
  libtorrent = (python3.pkgs.toPythonModule (
    libtorrent-rasterbar-1_2_x.override { python = python3; })).python;
in
stdenv.mkDerivation rec {
  pname = "tribler";
  version = "7.10.0";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-v${version}.tar.xz";
    hash = "sha256-CVZOVOWS0fvfg1yDiWFRa4v4Tpzl8RMVBQ6z0Ib4hfQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    makeWrapper
  ];

  buildInputs = [
    python3.pkgs.python
  ];

  pythonPath = [
    libtorrent
  ] ++ (with python3.pkgs; [
    aiohttp
    aiohttp-apispec
    asynctest
    chardet
    cherrypy
    configobj
    cryptography
    decorator
    faker
    feedparser
    libnacl
    lz4
    m2crypto
    netifaces
    networkx
    pillow
    pony
    psutil
    pyasn1
    pycrypto
    pyqt5
    pyqtgraph
    pytest-asyncio
    pytest-timeout
    pyyaml
    requests
    sentry-sdk
    service-identity
    twisted
    yappi
  ]);

  installPhase = ''
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${python3.pkgs.python}/bin/python $out/bin/tribler \
        --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms \
        --set _TRIBLERPATH $out/src \
        --set PYTHONPATH $out/src/tribler-core:$out/src/tribler-common:$out/src/tribler-gui:$program_PYTHONPATH \
        --set NO_AT_BRIDGE 1 \
        --run 'cd $_TRIBLERPATH' \
        --add-flags "-O $out/src/run_tribler.py"

    mkdir -p $out/share/applications $out/share/icons
    cp $out/build/debian/tribler/usr/share/applications/tribler.desktop $out/share/applications/tribler.desktop
    cp $out/build/debian/tribler/usr/share/pixmaps/tribler_big.xpm $out/share/icons/tribler.xpm
  '';

  meta = with lib; {
    description = "Decentralised P2P filesharing client based on the Bittorrent protocol";
    homepage = "https://www.tribler.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xvapx viric ];
    platforms = platforms.linux;
  };
}
