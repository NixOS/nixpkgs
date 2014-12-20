{ stdenv, fetchgit, libtorrentRasterbar, libav, pythonPackages, makeWrapper, nettools
, enablePlayer ? false, vlc ? null }:

let ver = "6.4.0"; in

stdenv.mkDerivation {
  name = "tribler-${ver}";

  src = fetchgit {
    url = "git://github.com/Tribler/tribler";
    rev = "v${ver}";
    sha256 = "c21fe700942df96e2f45f950d2800251e525664f0d5c39bf977a6c24499ec219";
    fetchSubmodules = true;
  };

  buildInputs =
    [ pythonPackages.python pythonPackages.gmpy pythonPackages.wrapPython makeWrapper
      libav ];

  pythonPath =
    [ pythonPackages.wxPython pythonPackages.curses pythonPackages.apsw
      pythonPackages.setuptools pythonPackages.m2crypto pythonPackages.sqlite3
      pythonPackages.twisted libtorrentRasterbar pythonPackages.pil pythonPackages.pyasn1
      pythonPackages.pycrypto pythonPackages.requests pythonPackages.netifaces
      pythonPackages.gmpy pythonPackages.cherrypy pythonPackages.feedparser
    ];

  propogatedBuildInputs =
    [ pythonPackages.netifaces ];

  installPhase =
    ''
    
      # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
      wrapPythonPrograms
      
      mkdir -p $out/share/tribler
      cp -prvd Tribler $out/share/tribler/

      makeWrapper ${pythonPackages.python}/bin/python $out/bin/tribler \
          --set _TRIBLERPATH $out/share/tribler \
          --set PYTHONPATH $out/share/tribler:$program_PYTHONPATH \
          --run 'cd $_TRIBLERPATH' \
          --add-flags "-O $out/share/tribler/Tribler/Main/tribler.py" \
          ${stdenv.lib.optionalString enablePlayer ''
            --prefix LD_LIBRARY_PATH : ${vlc}/lib
          ''}
    '';

  meta = {
    homepage = http://www.tribler.org/;
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = stdenv.lib.licenses.lgpl21;
  };
}
