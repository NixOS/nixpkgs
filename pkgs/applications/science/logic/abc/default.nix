{ stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2020.06.22";

  src = fetchFromGitHub {
    owner  = "berkeley-abc";
    repo   = "abc";
    rev    = "341db25668f3054c87aa3372c794e180f629af5d";
    sha256 = "14cgv34vz5ljkcms6nrv19vqws2hs8bgjgffk5q03cbxnm2jxv5s";
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
