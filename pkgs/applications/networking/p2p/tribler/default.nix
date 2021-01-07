{ stdenv, fetchurl, pkgs, python3Packages, makeWrapper
, enablePlayer ? true, libvlc ? null, qt5, lib }:

stdenv.mkDerivation rec {
  pname = "tribler";
  version = "7.4.4";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-v${version}.tar.xz";
    sha256 = "0hxiyf1k07ngym2p8r1b5mcx1y2crkyz43gi9sgvsvsyijyaff3p";
  };

  nativeBuildInputs = [
    python3Packages.wrapPython
    makeWrapper
  ];

  buildInputs = [
    python3Packages.python
  ];

  pythonPath = with python3Packages; [
    libtorrent-rasterbar
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

    # there is a BTC feature, but it requires some unclear version of
    # bitcoinlib, so this doesn't work right now.
    # bitcoinlib
  ];

  postPatch = ''
    ${stdenv.lib.optionalString enablePlayer ''
      substituteInPlace "./TriblerGUI/vlc.py" --replace "ctypes.CDLL(p)" "ctypes.CDLL('${libvlc}/lib/libvlc.so')"
      substituteInPlace "./TriblerGUI/widgets/videoplayerpage.py" \
        --replace "if vlc and vlc.plugin_path" "if vlc" \
        --replace "os.environ['VLC_PLUGIN_PATH'] = vlc.plugin_path" "os.environ['VLC_PLUGIN_PATH'] = '${libvlc}/lib/vlc/plugins'"
    ''}
  '';

  installPhase = ''
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${python3Packages.python}/bin/python $out/bin/tribler \
        --set QT_QPA_PLATFORM_PLUGIN_PATH ${qt5.qtbase.bin}/lib/qt-*/plugins/platforms \
        --set _TRIBLERPATH $out \
        --set PYTHONPATH $out:$program_PYTHONPATH \
        --set NO_AT_BRIDGE 1 \
        --run 'cd $_TRIBLERPATH' \
        --add-flags "-O $out/run_tribler.py" \
        ${stdenv.lib.optionalString enablePlayer ''
          --prefix LD_LIBRARY_PATH : ${libvlc}/lib
        ''}

    mkdir -p $out/share/applications $out/share/icons $out/share/man/man1
    cp $out/Tribler/Main/Build/Ubuntu/tribler.desktop $out/share/applications/tribler.desktop
    cp $out/Tribler/Main/Build/Ubuntu/tribler_big.xpm $out/share/icons/tribler.xpm
    cp $out/Tribler/Main/Build/Ubuntu/tribler.1 $out/share/man/man1/tribler.1
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ xvapx ];
    homepage = "https://www.tribler.org/";
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
