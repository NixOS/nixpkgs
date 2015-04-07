{ fetchhg, stdenv, readline }:

stdenv.mkDerivation rec {
  name = "abc-verifier-${version}";
  version = "20150406";

  src = fetchhg {
    url    = "https://bitbucket.org/alanmi/abc";
    rev    = "7d9c50a17d8676ad0c9792bb87102d7cb4b10667";
    sha256 = "1gg5jjfjjnv0fl7jsz37hzd9dpv58r8p0q8qvms0r289fcdxalcx";
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
    description = "Sequential Logic Synthesis and Formal Verification";
    homepage    = "www.eecs.berkeley.edu/~alanmi/abc/abc.htm";
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
