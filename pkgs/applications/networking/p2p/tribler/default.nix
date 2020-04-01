{ stdenv, fetchurl, pkgs, python3Packages, makeWrapper
, enablePlayer ? true, vlc ? null, qt5, lib }:

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

  pythonPath = [
    python3Packages.libtorrentRasterbar
    python3Packages.twisted
    python3Packages.netifaces
    python3Packages.pycrypto
    python3Packages.pyasn1
    python3Packages.requests
    python3Packages.m2crypto
    python3Packages.pyqt5
    python3Packages.chardet
    python3Packages.cherrypy
    python3Packages.cryptography
    python3Packages.libnacl
    python3Packages.configobj
    python3Packages.decorator
    python3Packages.feedparser
    python3Packages.service-identity
    python3Packages.psutil
    python3Packages.pillow
    python3Packages.networkx
    python3Packages.pony
    python3Packages.lz4
    python3Packages.pyqtgraph

    # there is a BTC feature, but it requires some unclear version of
    # bitcoinlib, so this doesn't work right now.
    # python3Packages.bitcoinlib
  ];

  postPatch = ''
    ${stdenv.lib.optionalString enablePlayer ''
      substituteInPlace "./TriblerGUI/vlc.py" --replace "ctypes.CDLL(p)" "ctypes.CDLL('${vlc}/lib/libvlc.so')"
      substituteInPlace "./TriblerGUI/widgets/videoplayerpage.py" --replace "if vlc and vlc.plugin_path" "if vlc"
      substituteInPlace "./TriblerGUI/widgets/videoplayerpage.py" --replace "os.environ['VLC_PLUGIN_PATH'] = vlc.plugin_path" "os.environ['VLC_PLUGIN_PATH'] = '${vlc}/lib/vlc/plugins'"
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
          --prefix LD_LIBRARY_PATH : ${vlc}/lib
        ''}
  '';

  meta = with stdenv.lib; {
    maintainers = with maintainers; [ xvapx ];
    homepage = "https://www.tribler.org/";
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
