{ stdenv, fetchsvn, pythonPackages, makeWrapper, nettools }:

let rev = "22245"; in

stdenv.mkDerivation {
  name = "tribler-5.4.2-pre${rev}";

  src = fetchsvn {
    url = http://svn.tribler.org/abc/branches/release-5.4.x;
    inherit rev;
    sha256 = "09b3iz3yy1dpl30cd2iningzhm1grz6qjgv0qb3wk0v1vxkacddz";
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
