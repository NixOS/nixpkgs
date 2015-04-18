{ stdenv, fetchgit, libtorrentRasterbar, libav, sqlite3, gmpy, twisted, pythonPackages, makeWrapper, nettools
, enablePlayer ? false, vlc ? null }:

let ver = "6.4.3"; in

stdenv.mkDerivation {
  name = "tribler-${ver}";

  src = fetchgit {
    url = git://github.com/Tribler/tribler;
    rev = "refs/tags/v${ver}";
    sha256 = "0i7pwqd4yizbv2z6ckz6897dw21parl1mvml4yvn522ry6hgvk3k";
    fetchSubmodules = true;
  };

  buildInputs =
    [ pythonPackages.python pythonPackages.gmpy pythonPackages.wrapPython makeWrapper
      libav ];

  pythonPath = with pythonPackages; [
      wxPython curses apsw setuptools m2crypto gmpy twisted feedparser
      sqlite3 pil libtorrentRasterbar pyasn1 pycrypto requests netifaces cherrypy
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
