{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2022.03.04";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "d7ecb23eeee9c9b4924182ce570c2e33eb18abff";
    hash  = "sha256-aufWRTggJNOaUFsjh5+HFDqEur+nuM0hZSsTfGptbks=";
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
