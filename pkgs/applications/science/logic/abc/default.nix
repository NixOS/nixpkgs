{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "unstable-2023-02-04";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "a8f0ef2368aa56b3ad20a52298a02e63b2a93e2d";
    hash  = "sha256-48i6AKQhMG5hcnkS0vejOy1PqFbeb6FpU7Yx0rEvHDI=";
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
