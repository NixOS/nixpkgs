{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2022.07.27";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "7cc11f7f0c49d4ce7e0ed88950d1c4c8abb1cba4";
    hash  = "sha256-6m8XpSYWT0uMpYHXm3ExnH7RMg923YqZAJPTBeFXMzg=";
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
