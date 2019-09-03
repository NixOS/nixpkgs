{ fetchFromGitHub, stdenv, readline, cmake }:

stdenv.mkDerivation rec {
  pname = "abc-verifier";
  version = "2018-07-08";

  src = fetchFromGitHub {
    owner = "berkeley-abc";
    repo = "abc";
    rev    = "24407e13db4b8ca16c3996049b2d33ec3722de39";
    sha256 = "1rckji7nk81n6v1yajz7daqwipxacv7zlafknvmbiwji30j47sq5";
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
