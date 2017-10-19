{ fetchhg, stdenv, pkgs }:

stdenv.mkDerivation rec {

  # Note that this derivation provides only the library, but under the
  # "abc" name, to associate with libabc, which conforms to the
  # standard library dependency referencing nomenclature.  The binary
  # is available as a separate package with the "abc-verifier" naming.

  name = "abc-${version}";
  version = "20160818";

  src = fetchhg {
    url    = "https://bitbucket.org/alanmi/abc";
    rev    = "a2e5bc66a68a72ccd267949e5c9973dd18f8932a";
    sha256 = "09yvhj53af91nc54gmy7cbp7yljfcyj68a87494r5xvdfnsj11gy";
  };

  preBuild = ''
    export buildFlags="CC=$CC CXX=$CXX LD=$CXX ABC_USE_NO_READLINE=1 libabc.a"
  '';

  # n.b. the following are documented, but libabc.so is not a valid make target:
  # ABC_USE_PIC=1 libabc.so

  enableParallelBuilding = true;
  installPhase = ''
    mkdir -p $out/lib
    mv libabc.a $out/lib
    # mv libabc.so $out/lib
  '';

  meta = {
    description = "A library for sequential logic synthesis and formal verification";
    homepage    = "https://people.eecs.berkeley.edu/~alanmi/abc/abc.htm";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.kquick ];
  };
}
