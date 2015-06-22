{ fetchhg, stdenv, readline }:

stdenv.mkDerivation rec {
  name = "abc-verifier-${version}";
  version = "20150614";

  src = fetchhg {
    url    = "https://bitbucket.org/alanmi/abc";
    rev    = "38661894bc1287cad9bd35978bd252dbfe3e6c56";
    sha256 = "04v0hkvj501r10pj3yrqrk2463d1d7lhl8dzfjwkmlbmlmpjlvvv";
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
