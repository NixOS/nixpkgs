{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2022.03.22";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "00b674d5b3ccefc7f2abcbf5b650fc14298ac549";
    hash  = "sha256-jQgHptARRuhlF+8R92so8PyBTI5t/q/rSGO5yce5WSs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ readline ];

  installPhase = "mkdir -p $out/bin && mv abc $out/bin";

  # needed by yosys
  passthru.rev = src.rev;

  meta = with lib; {
    description = "A tool for squential logic synthesis and formal verification";
    homepage    = "https://people.eecs.berkeley.edu/~alanmi/abc";
    license     = licenses.mit;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
