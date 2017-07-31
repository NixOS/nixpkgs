{stdenv, fetchurl}:
stdenv.mkDerivation rec {
  name = "symmetrica-${version}";
  version = "2.0";
  # or fetchFromGitHub(owner,repo,rev) or fetchgit(rev)
  src = fetchurl {
    url = "http://www.algorithm.uni-bayreuth.de/en/research/SYMMETRICA/SYM2_0_tar.gz";
    sha256 = "1qhfrbd5ybb0sinl9pad64rscr08qvlfzrzmi4p4hk61xn6phlmz";
    name = "symmetrica-2.0.tar.gz";
  };
  buildInputs = [];
  sourceRoot = ".";
  installPhase = ''
    mkdir -p "$out"/{lib,share/doc/symmetrica,include/symmetrica}
    ar crs libsymmetrica.a *.o
    ranlib libsymmetrica.a
    cp libsymmetrica.a "$out/lib"
    cp *.h "$out/include/symmetrica"
    cp README *.doc "$out/share/doc/symmetrica"
  '';
  meta = {
    inherit version;
    description = ''A collection of routines for representation theory and combinatorics'';
    license = stdenv.lib.licenses.publicDomain;
    maintainers = [stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.linux;
    homepage = http://www.symmetrica.de/;
  };
}
