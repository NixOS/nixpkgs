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
  version = "7.11.0";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-v${version}.tar.xz";
    sha256 = "0ffh8chb47iaar8872gvalgm84fjzyxph16nixsxknnprqdxyrkx";
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
    pydantic
    anyio
  ]);

  installPhase = ''
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${python3.pkgs.python}/bin/python $out/bin/tribler \
        --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms \
        --set QT_PLUGIN_PATH "${qt5.qtsvg.bin}/${qt5.qtbase.qtPluginPrefix}" \
        --set _TRIBLERPATH "$out/src" \
        --set PYTHONPATH $out/src/tribler-core:$out/src/tribler-common:$out/src/tribler-gui:$program_PYTHONPATH \
        --set NO_AT_BRIDGE 1 \
        --chdir "$out/src" \
        --add-flags "-O $out/src/run_tribler.py"

    mkdir -p $out/share/applications $out/share/icons
    cp $out/build/debian/tribler/usr/share/applications/org.tribler.Tribler.desktop $out/share/applications/
    cp $out/build/debian/tribler/usr/share/pixmaps/tribler_big.xpm $out/share/icons/tribler.xpm
  '';

  shellHook = ''
    wrapPythonPrograms || true
    export QT_QPA_PLATFORM_PLUGIN_PATH=$(echo ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms)
    export PYTHONPATH=./tribler-core:./tribler-common:./tribler-gui:$program_PYTHONPATH
    export QT_PLUGIN_PATH="${qt5.qtsvg.bin}/${qt5.qtbase.qtPluginPrefix}"
  '';

  meta = with lib; {
    description = "Decentralised P2P filesharing client based on the Bittorrent protocol";
    homepage = "https://www.tribler.org/";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xvapx viric ];
    platforms = platforms.linux;
  };
}
