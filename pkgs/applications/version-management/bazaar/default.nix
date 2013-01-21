{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "2.5";
  release = ".1";
  name = "bazaar-${version}${release}";

  src = fetchurl {
    url = "http://launchpad.net/bzr/${version}/${version}${release}/+download/bzr-${version}${release}.tar.gz";
    sha256 = "10krjbzia2avn09p0cdlbx2wya0r5v11w5ymvyl72af5dkx4cwwn";
  };

  buildInputs = [ pythonPackages.python pythonPackages.wrapPython ];

  # Readline support is needed by bzrtools.
  pythonPath = [ pythonPackages.readline ];

  installPhase = ''
    python setup.py install --prefix=$out
    wrapPythonPrograms
  '';

  meta = {
    homepage = http://bazaar-vcs.org/;
    description = "A distributed version control system that Just Works";
    platforms = stdenv.lib.platforms.linux;
  };
}
