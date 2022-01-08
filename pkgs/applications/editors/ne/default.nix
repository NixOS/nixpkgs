{ lib, stdenv, fetchFromGitHub, ncurses, texinfo, texlive, perl, ghostscript }:

stdenv.mkDerivation rec {
  pname = "ne";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "vigna";
    repo = pname;
    rev = version;
    sha256 = "sha256-75xsZ9X6nmRj0VVZmY1AeEOBtO2d7jbanZIZ3Klx4mk=";
  };

  postPatch = ''
    substituteInPlace makefile --replace "./version.pl" "perl version.pl"
    substituteInPlace src/makefile --replace "-lcurses" "-lncurses"
  '';

  nativeBuildInputs = [ texlive.combined.scheme-medium texinfo perl ghostscript ];
  buildInputs = [ ncurses ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  meta = with lib; {
    description = "The nice editor";
    homepage = "https://ne.di.unimi.it/";
    longDescription = ''
      ne is a free (GPL'd) text editor based on the POSIX standard that runs
      (we hope) on almost any UN*X machine.  ne is easy to use for the beginner,
      but powerful and fully configurable for the wizard, and most sparing in its
      resource usage.  See the manual for some highlights of ne's features.
    '';
    license = licenses.gpl3;
    platforms = platforms.unix;
  };
}
