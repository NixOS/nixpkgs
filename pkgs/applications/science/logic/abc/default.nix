{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
  version = "2020.11.24";

  src = fetchFromGitHub {
    owner  = "yosyshq";
    repo   = "abc";
    rev    = "4f5f73d18b137930fb3048c0b385c82fa078db38";
    sha256 = "0z1kp223kix7i4r7mbj2bzawkdzc55nsgc41m85dmbajl9fsj1m0";
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
