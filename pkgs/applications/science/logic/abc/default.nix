{ fetchFromGitHub, stdenv, readline, cmake }:

stdenv.mkDerivation {
  pname = "abc-verifier";
  version = "2020-01-11";

  src = fetchFromGitHub {
    owner = "berkeley-abc";
    repo = "abc";
    rev    = "71f2b40320127561175ad60f6f2428f3438e5243";
    sha256 = "15sn146ajxql7l1h8rsag5lhn4spwvgjhwzqawfr78snzadw8by3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  enableParallelBuilding = true;

  installPhase = ''
    mkdir -p $out/bin
    mv abc $out/bin
  '';

  meta = {
    description = "A tool for squential logic synthesis and formal verification";
    homepage    = https://people.eecs.berkeley.edu/~alanmi/abc;
    license     = stdenv.lib.licenses.mit;
    platforms   = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
