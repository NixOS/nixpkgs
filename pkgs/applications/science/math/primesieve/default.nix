{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "primesieve";
<<<<<<< HEAD
  version = "11.1";
=======
  version = "11.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "kimwalisch";
    repo = "primesieve";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-b6X3zhoJsO3UiWfeW4zbKsaoofIWArJi5usof3efQ0k=";
=======
    hash = "sha256-mYekOfjeGwQzWi3pBXnmRMTV7nghEvHsD+tR7vrTFRY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://primesieve.org/";
    changelog = "https://github.com/kimwalisch/primesieve/blob/v${version}/ChangeLog";
    description = "Fast C/C++ prime number generator";
    longDescription = ''
      primesieve is a command-line program and C/C++ library for quickly
      generating prime numbers. It is very cache efficient, it detects your
      CPU's L1 & L2 cache sizes and allocates its main data structures
      accordingly. It is also multi-threaded by default, it uses all available
      CPU cores whenever possible i.e. if sequential ordering is not
      required. primesieve can generate primes and prime k-tuplets up to 264.
    '';
    license = licenses.bsd2;
    maintainers = teams.sage.members ++
      (with maintainers; [ abbradar AndersonTorres ]);
    platforms = platforms.unix;
  };
}
