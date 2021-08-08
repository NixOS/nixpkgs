{ lib, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, flint
, gmp
, python3
, singular
, ncurses
}:

stdenv.mkDerivation rec {
  version = "0.7.29";
  pname = "pynac";

  src = fetchFromGitHub {
    owner = "pynac";
    repo = "pynac";
    rev = "pynac-${version}";
    sha256 = "sha256-ocR7emXtKs+Xe2f6dh4xEDAacgiolY8mtlLnWnNBS8A=";
  };

  buildInputs = [
    flint
    gmp
    singular
    python3
    ncurses
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "Python is Not a CAS -- modified version of Ginac";
    longDescription = ''
      Pynac -- "Python is Not a CAS" is a modified version of Ginac that
      replaces the depency of GiNaC on CLN by a dependency instead of Python.
      It is a lite version of GiNaC as well, not implementing all the features
      of the full GiNaC, and it is *only* meant to be used as a Python library.
    '';
    homepage    = "http://pynac.org";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms   = platforms.unix;
  };
}
