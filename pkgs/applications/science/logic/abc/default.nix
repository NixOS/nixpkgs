{ fetchhg, stdenv, readline }:

stdenv.mkDerivation rec {
  name = "abc-verifier-${version}";
  version = "20160818";

  src = fetchhg {
    url    = "https://bitbucket.org/alanmi/abc";
    rev    = "a2e5bc66a68a72ccd267949e5c9973dd18f8932a";
    sha256 = "09yvhj53af91nc54gmy7cbp7yljfcyj68a87494r5xvdfnsj11gy";
  };

  buildInputs = [ readline ];
  preBuild = ''
    export buildFlags="CC=$CC CXX=$CXX LD=$CXX"
  '';
  enableParallelBuilding = true;
  installPhase = ''
    mkdir -p $out/bin
    mv abc $out/bin
  '';

  meta = {
    description = "A tool for squential logic synthesis and ormal verification";
    homepage    = "www.eecs.berkeley.edu/~alanmi/abc/abc.htm";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
