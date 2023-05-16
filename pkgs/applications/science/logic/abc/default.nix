{ lib, stdenv, fetchFromGitHub
, readline, cmake
}:

stdenv.mkDerivation rec {
  pname   = "abc-verifier";
<<<<<<< HEAD
  version = "unstable-2023-06-28";
=======
  version = "unstable-2023-02-23";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "yosyshq";
    repo  = "abc";
<<<<<<< HEAD
    rev   = "bb64142b07794ee685494564471e67365a093710";
    hash  = "sha256-Qkk61Lh84ervtehWskSB9GKh+JPB7mI1IuG32OSZMdg=";
=======
    rev   = "2c1c83f75b8078ced51f92c697da3e712feb3ac3";
    hash  = "sha256-THcyEifIp9v1bOofFVm9NFPqgI6NfKKys+Ea2KyNpv8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
