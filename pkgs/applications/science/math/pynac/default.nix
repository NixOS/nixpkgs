{ stdenv
, fetchFromGitHub
, autoreconfHook
, pkgconfig
, flint
, gmp
, python2
, singular
}:

stdenv.mkDerivation rec {
  version = "0.7.23";
  name = "pynac-${version}";

  src = fetchFromGitHub {
    owner = "pynac";
    repo = "pynac";
    rev = "pynac-${version}";
    sha256 = "02yhl8v9l6aj3wl6dk9iacz4hdv08i1d750rxpygjp43nlgvvb2h";
  };

  buildInputs = [
    flint
    gmp
    singular
    singular
    python2
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
  ];

  meta = with stdenv.lib; {
    description = "Python is Not a CAS -- modified version of Ginac";
    longDescription = ''
      Pynac -- "Python is Not a CAS" is a modified version of Ginac that
      replaces the depency of GiNaC on CLN by a dependency instead of Python.
      It is a lite version of GiNaC as well, not implementing all the features
      of the full GiNaC, and it is *only* meant to be used as a Python library.
    '';
    homepage    = http://pynac.org;
    license = licenses.gpl3;
    maintainers = with maintainers; [ timokau ];
    platforms   = platforms.linux;
  };
}
