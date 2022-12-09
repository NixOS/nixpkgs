{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "unstable-2022-11-09";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "be9a35c0363174a7cef21d55ed80d92a9ef95ab1";
    hash  = "sha256-IN9YgJONcC55N89OXMrMuNuznTdjXNWxR0IngH8OWC8=";
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
