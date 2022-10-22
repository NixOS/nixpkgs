{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "unstable-2022-09-08";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "ab5b16ede2ff3a4ab5209df24db2c76700899684";
    hash  = "sha256-G4MnBViwIosFDiPfUimGqf6fq1KJlxj+LozmgoKaH3A=";
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
