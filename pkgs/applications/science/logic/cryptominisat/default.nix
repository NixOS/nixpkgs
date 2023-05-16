{ lib
, stdenv
, fetchFromGitHub
, cmake
, python3
, boost
}:

stdenv.mkDerivation rec {
  pname = "cryptominisat";
<<<<<<< HEAD
  version = "5.11.12";
=======
  version = "5.11.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "msoos";
    repo = "cryptominisat";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-1AJx8gPf+qDpAp0p4cfCObKZDWKDAKdGopllr2ajpHw=";
=======
    hash = "sha256-7JNfFKSYWgyyNnWNzXGLqWRwSW+5r6PBMelKeAmx8sc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ python3 boost ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "An advanced SAT Solver";
    homepage = "https://github.com/msoos/cryptominisat";
    license = licenses.mit;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
