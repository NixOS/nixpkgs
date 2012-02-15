{ stdenv, fetchsvn, pythonPackages, makeWrapper, nettools }:

let rev = "24912"; in

stdenv.mkDerivation {
  name = "tribler-5.5.13-pre${rev}";

  src = fetchsvn {
    url = http://svn.tribler.org/abc/branches/release-5.5.x;
    inherit rev;
    sha256 = "1x4rf83gsxif7fwx7p4crfji52i5y8rp54qfv1lbyxr8dfqjx83g";
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
          --add-flags "-O $out/share/tribler/Tribler/Main/tribler.py"
    '';

  meta = {
    homepage = http://www.tribler.org/;
    description = "A completely decentralised P2P filesharing client based on the Bittorrent protocol";
    license = "LGPLv2.1";
  };
}
