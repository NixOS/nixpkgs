{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "unstable-2023-02-23";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "2c1c83f75b8078ced51f92c697da3e712feb3ac3";
    hash  = "sha256-THcyEifIp9v1bOofFVm9NFPqgI6NfKKys+Ea2KyNpv8=";
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
