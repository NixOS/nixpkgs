{ stdenv, fetchurl, pythonPackages, makeWrapper, imagemagick
, enablePlayer ? true, vlc ? null, qt5 }:

stdenv.mkDerivation rec {
  pname = "tribler";
  version = "7.1.2";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/releases/download/v${version}/Tribler-v${version}.tar.gz";
    sha256 = "1ayzqx4358qlx56hsnsn5s8xl6mzdb6nw4kwsalmp86dw6vmmis8";
  };

  buildInputs = [
    pythonPackages.python
    pythonPackages.wrapPython
    makeWrapper
    imagemagick
  ];

  pythonPath = [
    pythonPackages.libtorrentRasterbar
    pythonPackages.apsw
    pythonPackages.twisted
    pythonPackages.netifaces
    pythonPackages.pycrypto
    pythonPackages.pyasn1
    pythonPackages.requests
    pythonPackages.setuptools
    pythonPackages.m2crypto
    pythonPackages.pyqt5
    pythonPackages.chardet
    pythonPackages.cherrypy
    pythonPackages.cryptography
    pythonPackages.libnacl
    pythonPackages.configobj
    pythonPackages.matplotlib
    pythonPackages.plyvel
    pythonPackages.decorator
    pythonPackages.feedparser
    pythonPackages.service-identity
    pythonPackages.psutil
    pythonPackages.meliae
    pythonPackages.sip
    pythonPackages.pillow
    pythonPackages.networkx
  ];

  postPatch = ''
    ${stdenv.lib.optionalString enablePlayer ''
      substituteInPlace "./TriblerGUI/vlc.py" --replace "ctypes.CDLL(p)" "ctypes.CDLL('${vlc}/lib/libvlc.so')"
      substituteInPlace "./TriblerGUI/widgets/videoplayerpage.py" --replace "if vlc and vlc.plugin_path" "if vlc"
      substituteInPlace "./TriblerGUI/widgets/videoplayerpage.py" --replace "os.environ['VLC_PLUGIN_PATH'] = vlc.plugin_path" "os.environ['VLC_PLUGIN_PATH'] = '${vlc}/lib/vlc/plugins'"
    ''}
  '';

  installPhase = ''
    find . -name '*.png' -exec convert -strip {} {} \;
    mkdir -pv $out
    # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
    wrapPythonPrograms
    cp -prvd ./* $out/
    makeWrapper ${pythonPackages.python}/bin/python $out/bin/tribler \
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
    homepage = https://www.tribler.org/;
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
