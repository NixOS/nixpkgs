{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2022.07.01";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "18634305282c81b0f4a08de4ebca6ccc95b11748";
    hash  = "sha256-GwriIyrayRS+M0wErvIIUWHuh+FwlKpowvBjBgkdy4o=";
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
    maintainers = with maintainers; [ thoughtpolice ];
    mainProgram = "abc";
    platforms   = platforms.unix;
  };
}
