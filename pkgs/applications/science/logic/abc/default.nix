{ stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2020.03.05";

  src = fetchFromGitHub {
    owner  = "berkeley-abc";
    repo   = "abc";
    rev    = "ed90ce20df9c7c4d6e1db5d3f786f9b52e06bab1";
    sha256 = "01sw67pkrb6wzflkxbkxzwsnli3nvp0yxwp3j1ngb3c0j86ri437";
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
