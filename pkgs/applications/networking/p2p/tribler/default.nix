{ stdenv, fetchsvn, pythonPackages, makeWrapper, nettools }:

stdenv.mkDerivation {
  name = "tribler-5.3.9-pre21071";

  src = fetchsvn {
    url = http://svn.tribler.org/abc/branches/release-5.3.x;
    rev = 21071;
    sha256 = "0plzw5m9rligz66rbq8qr9sj0fiqx8gwmchdw3p4mwlwfx72gixm";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython makeWrapper ];

  pythonPath =
    [ pythonPackages.wxPython pythonPackages.ssl pythonPackages.curses pythonPackages.apsw
      pythonPackages.setuptools pythonPackages.m2crypto pythonPackages.sqlite3
    ];

  installPhase =
    ''
      substituteInPlace Tribler/Core/NATFirewall/guessip.py \
          --replace /bin/netstat ${nettools}/bin/netstat \
          --replace /sbin/ifconfig ${nettools}/sbin/ifconfig
    
      # Nasty hack; call wrapPythonPrograms to set program_PYTHONPATH.
      wrapPythonPrograms
      
      mkdir -p $out/share/tribler
      cp -prvd Tribler $out/share/tribler/

      makeWrapper ${pythonPackages.python}/bin/python $out/bin/tribler \
          --set _TRIBLERPATH $out/share/tribler \
          --set PYTHONPATH $out/share/tribler:$program_PYTHONPATH \
          --run 'cd $_TRIBLERPATH' \
          --add-flags $out/share/tribler/Tribler/Main/tribler.py
    '';

  meta = {
    homepage = http://www.tribler.org/;
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = "LGPLv2.1";
  };
}
