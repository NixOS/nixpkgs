{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2021.11.12";

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
    rev   = "f6fa2ddcfc89099726d60386befba874c7ac1e0d";
    hash  = "sha256-0rvMPZ+kL0m/GjlCLx3eXYQ0osQ2wQiS3+csqPl3U9s=";
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
