{ stdenv, fetchurl, pythonPackages }:

stdenv.mkDerivation rec {
  version = "2.3";
  release = ".1";
  name = "bazaar-${version}${release}";

  src = fetchurl {
    url = "http://launchpad.net/bzr/${version}/${version}${release}/+download/bzr-${version}${release}.tar.gz";
    sha256 = "07kx41w4gqv68bcykdflsg68wvpmcyqknzyb4vr1zqlf27hahp53";
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
  };
}
