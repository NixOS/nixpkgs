{ stdenv, fetchgit, pythonPackages, makeWrapper, nettools, libtorrentRasterbar, imagemagick
, enablePlayer ? true, vlc ? null }:

stdenv.mkDerivation rec {
  pname = "tribler";
  name = "${pname}-${version}";
  version = "7.0.0-beta";
  revision = "1d3ddb8";

  src = fetchgit {
    url = "https://github.com/Tribler/tribler";
    rev = revision;
    sha256 = "16mk76qgg7fgca11yvpygicxqbkc0kn6r82x73fly2310pagd845";
    fetchSubmodules = true;
  };

  buildInputs = [
    pythonPackages.python
    pythonPackages.wrapPython
    makeWrapper
    imagemagick
  ];

  pythonPath = [
    libtorrentRasterbar
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
    homepage = http://www.tribler.org/;
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.linux;
  };
}
