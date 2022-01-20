{ stdenv, lib, fetchurl, python3, makeWrapper
, libtorrent-rasterbar-1_2_x, qt5
}:

let
  libtorrent = (python3.pkgs.toPythonModule (
    libtorrent-rasterbar-1_2_x.override { python = python3; })).python;

  aiohttp-apispec = python3.pkgs.callPackage ./aiohttp-apispec.nix { };
in
stdenv.mkDerivation rec {
  pname = "tribler";
  version = "7.10.0";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-v${version}.tar.xz";
    sha256 = "1x45z23d1cqf0lai7wg5ki7gi2vba5hqk0swhggzplcjwma4wmh9";
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
    twisted
    netifaces
    pycrypto
    pyasn1
    requests
    m2crypto
    pyqt5
    chardet
    cherrypy
    cryptography
    libnacl
    configobj
    decorator
    feedparser
    service-identity
    psutil
    pillow
    networkx
    pony
    lz4
    pyqtgraph
    pyyaml
    aiohttp
    aiohttp-apispec
    faker
    sentry-sdk
    pytest-asyncio
    pytest-timeout
    asynctest
    yappi

    # there is a BTC feature, but it requires some unclear version of
    # bitcoinlib, so this doesn't work right now.
    # bitcoinlib
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
    maintainers = with maintainers; [ xvapx viric ];
    homepage = "https://www.tribler.org/";
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
