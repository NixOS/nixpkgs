{ fetchhg, stdenv, readline }:

stdenv.mkDerivation rec {
  name = "abc-verifier-${version}";
  version = "20160813";

  src = fetchhg {
    url    = "https://bitbucket.org/alanmi/abc";
    rev    = "1df0b06d7bf615c50014df0952a61e11891ee306";
    sha256 = "0i0b9i2gs0y1q8nqnqyzfbff8aiknzja27m383nvccxscvg355z5";
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
