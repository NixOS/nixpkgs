{ fetchhg, stdenv, readline }:

stdenv.mkDerivation rec {
  name = "abc-verifier-${version}";
  version = "140509"; # YYMMDD

  src = fetchhg {
    url    = "https://bitbucket.org/alanmi/abc";
    rev    = "03e221443d71e49e56cbc37f1907ee3b0ff3e7c9";
    sha256 = "0ahrqg718y7xpv939f6x8w1kqh7wsja4pw8hca7j67j0qjdgb4lm";
  };

  buildInputs = [ readline ];
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
