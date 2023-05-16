{ stdenv, lib, fetchFromGitHub, libcap, acl, file, readline }:

stdenv.mkDerivation rec {
  pname = "clifm";
<<<<<<< HEAD
  version = "1.13";
=======
  version = "1.10";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "leo-arch";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-Y9z3HT36Z1fwweOnniRgyNQX1cbrLSGGgB5UAxkq9mI=";
=======
    sha256 = "sha256-kXnI8a1nGKBDc+isv9RYvputKk+/FHmM9j+G4UnI5Z4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ libcap acl file readline ];

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "DATADIR=/share"
    "PREFIX=/"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/leo-arch/clifm";
    description = "CliFM is a CLI-based, shell-like, and non-curses terminal file manager written in C: simple, fast, extensible, and lightweight as hell";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
