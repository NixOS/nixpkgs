{ lib
, stdenv
, fetchurl
, fetchPypi
, python3
, makeWrapper
, libtorrent-rasterbar-1_2_x
, qt5
}:

let
  libtorrent = (python3.pkgs.toPythonModule (libtorrent-rasterbar-1_2_x)).python;
in
stdenv.mkDerivation rec {
  pname = "tribler";
  version = "7.13.0";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-${version}.tar.xz";
    hash = "sha256-j9+Kq6dOqiJCTY3vuRWGnciuwACU7L0pl73l6nkDLN4=";
  };

  nativeBuildInputs = [
    python3.pkgs.wrapPython
    makeWrapper
    # we had a "copy" of this in tribler's makeWrapper
    # but it went out of date and broke, so please just use it directly
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    python3.pkgs.python
  ];

  pythonPath = [
    libtorrent
  ] ++ (with python3.pkgs; [
    # requirements-core.txt
    aiohttp
    aiohttp-apispec
    anyio
    chardet
    configobj
    cryptography
    decorator
    faker
    libnacl
    lz4
    marshmallow
    netifaces
    networkx
    pony
    psutil
    pyasn1
    pydantic
    pyopenssl
    pyyaml
    sentry-sdk
    service-identity
    yappi
    yarl
    bitarray
    (pyipv8.overrideAttrs (p: rec {
      version = "2.10.0";
      src = fetchPypi {
        inherit (p) pname;
        inherit version;
        hash = "sha256-yxiXBxBiPokequm+vjsHIoG9kQnRnbsOx3mYOd8nmiU=";
      };
    }))
    libtorrent
    file-read-backwards
    brotli
    human-readable
    # requirements.txt
    pillow
    pyqt5
    #pyqt5-sip
    pyqtgraph
    pyqtwebengine
  ]);

  installPhase = ''
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${python3.pkgs.python}/bin/python $out/bin/tribler \
        --set _TRIBLERPATH "$out/src" \
        --set PYTHONPATH $out/src/tribler-core:$out/src/tribler-common:$out/src/tribler-gui:$program_PYTHONPATH \
        --set NO_AT_BRIDGE 1 \
        --chdir "$out/src" \
        --add-flags "-O $out/src/run_tribler.py"

    mkdir -p $out/share/applications $out/share/icons
    cp $out/build/debian/tribler/usr/share/applications/org.tribler.Tribler.desktop $out/share/applications/
    cp $out/build/debian/tribler/usr/share/pixmaps/tribler_big.xpm $out/share/icons/tribler.xpm
    mkdir -p $out/share/copyright/tribler
    mv $out/LICENSE $out/share/copyright/tribler
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
    maintainers = with maintainers; [ xvapx viric mkg20001 ];
    platforms = platforms.linux;
  };
}
