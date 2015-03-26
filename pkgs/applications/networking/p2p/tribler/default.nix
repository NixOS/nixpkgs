{ stdenv, fetchgit, pythonPackages, makeWrapper, nettools, libtorrent
, enablePlayer ? false, vlc ? null }:

stdenv.mkDerivation rec {
  name = "tribler-${version}";
  version = "6.4.3";

  src = fetchgit {
    url = https://github.com/Tribler/tribler.git;
    rev = "refs/tags/v${version}";
    sha256 = "0i7pwqd4yizbv2z6ckz6897dw21parl1mvml4yvn522ry6hgvk3k";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython makeWrapper ];

  pythonPath =
    [ pythonPackages.wxPython pythonPackages.apsw
      pythonPackages.m2crypto pythonPackages.sqlite3
      pythonPackages.twisted pythonPackages.pil pythonPackages.gmpy
      pythonPackages.pycrypto pythonPackages.pyasn1 pythonPackages.requests
      pythonPackages.netifaces
      libtorrent
    ];

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

  meta = with stdenv.lib; {
    homepage = http://www.tribler.org/;
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = licenses.lgpl21;
    platforms = platforms.unix;
    maintainers = [ maintainers.offline ];
  };
}
