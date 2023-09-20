{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "unstable-2023-06-28";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "bb64142b07794ee685494564471e67365a093710";
    hash  = "sha256-Qkk61Lh84ervtehWskSB9GKh+JPB7mI1IuG32OSZMdg=";
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
