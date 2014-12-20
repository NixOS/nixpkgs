{ stdenv, fetchurl, pythonPackages, makeWrapper, nettools
, enablePlayer ? false, vlc ? null }:

let ver = "6.4.0"; in

stdenv.mkDerivation {
  name = "tribler-${ver}";

  src = fetchurl {
    url = "https://github.com/Tribler/tribler/archive/v${ver}.tar.gz";
    sha256 = "03wsdlx4hnpc6ryxy872rkf9vhgzasgil9801l1p9ar0swdcyqrz";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython makeWrapper ];

  pythonPath =
    [ pythonPackages.wxPython pythonPackages.curses pythonPackages.apsw
      pythonPackages.setuptools pythonPackages.m2crypto pythonPackages.sqlite3
      pythonPackages.twisted pytonPackages.dispersy
    ];

  installPhase =
    ''
      #substituteInPlace Tribler/Core/NATFirewall/guessip.py \
      #    --replace /bin/netstat ${nettools}/bin/netstat \
      #    --replace /sbin/ifconfig ${nettools}/sbin/ifconfig
    
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
