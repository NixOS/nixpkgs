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
  version = "0.7.22";
  name = "pynac-${version}";

  src = fetchFromGitHub {
    owner = "pynac";
    repo = "pynac";
    rev = "pynac-${version}";
    sha256 = "1ribm5vpbgsja4hbca1ckw4ln9kjkv608aaqsvxxvbs4z76ys6yi";
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
