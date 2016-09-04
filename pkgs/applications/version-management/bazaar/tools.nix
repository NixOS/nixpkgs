{ stdenv, fetchurl, makeWrapper, python2, bazaar }:

stdenv.mkDerivation rec {
  name = "bzr-tools-${version}";
  version = "2.6.0";
  
  src = fetchurl {
    url = "http://launchpad.net/bzrtools/stable/${version}/+download/bzrtools-${version}.tar.gz";
    sha256 = "0n3zzc6jf5866kfhmrnya1vdr2ja137a45qrzsz8vz6sc6xgn5wb";
  };

  buildInputs = [ makeWrapper python2 ];

  installPhase = ''
    ${python2}/bin/python ./setup.py install --prefix=$out
  '';
      
  meta = {
    description = "Bazaar plugins";
    homepage = http://wiki.bazaar.canonical.com/BzrTools;
    platforms = stdenv.lib.platforms.unix;
  };
}
