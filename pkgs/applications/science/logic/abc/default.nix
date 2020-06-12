{ stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2020.04.30";

  src = fetchFromGitHub {
    owner  = "berkeley-abc";
    repo   = "abc";
    rev    = "fd2c9b1c19216f6b756f88b18f5ca67b759ca128";
    sha256 = "1d18pkpsx0nlzl3a6lyfdnpk4kixjmgswy6cp5fbrkpp4rf1gahi";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  enableParallelBuilding = true;
  installPhase = "mkdir -p $out/bin && mv abc $out/bin";

  # needed by yosys
  passthru.rev = src.rev;

  meta = with stdenv.lib; {
    description = "A tool for squential logic synthesis and formal verification";
    homepage    = "https://people.eecs.berkeley.edu/~alanmi/abc";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
