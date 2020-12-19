{ stdenv
, fetchFromGitHub
, fetchurl
, autoreconfHook
, pkgconfig
, flint
, gmp
, python3
, singular
, ncurses
}:

stdenv.mkDerivation rec {
  version = "0.7.26";
  pname = "pynac";

  src = fetchFromGitHub {
    owner = "pynac";
    repo = "pynac";
    rev = "pynac-${version}";
    sha256 = "09d2p74x1arkydlxy6pw4p4byi7r8q7f29w373h4d8a215kadc6d";
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
    pkgconfig
  ];

  patches = [
    (fetchurl {
      name = "py_ssize_t_clean.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/py_ssize_t_clean.patch?h=9.2";
      sha256 = "0l3gbg9hc4v671zf4w376krnk3wh8hj3649610nlvzzxckcryzab";
    })
  ];

  meta = with stdenv.lib; {
    description = "Python is Not a CAS -- modified version of Ginac";
    longDescription = ''
      Pynac -- "Python is Not a CAS" is a modified version of Ginac that
      replaces the depency of GiNaC on CLN by a dependency instead of Python.
      It is a lite version of GiNaC as well, not implementing all the features
      of the full GiNaC, and it is *only* meant to be used as a Python library.
    '';
    homepage    = "http://pynac.org";
    license = licenses.gpl3;
    maintainers = teams.sage.members;
    platforms   = platforms.unix;
  };
}
