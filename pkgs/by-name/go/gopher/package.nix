{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "gopher";
  version = "3.0.19";

  src = fetchFromGitHub {
    owner = "jgoerzen";
    repo = "gopher";
    rev = "release/${version}";
    sha256 = "sha256-8J63TnC3Yq7+64PPLrlPEueMa9D/eWkPsb08t1+rPAA=";
  };

  buildInputs = [ ncurses ];

  preConfigure = "export LIBS=-lncurses";

<<<<<<< HEAD
  meta = {
    homepage = "http://gopher.quux.org:70/devel/gopher";
    description = "Ncurses gopher client";
    platforms = lib.platforms.linux; # clang doesn't like local regex.h
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ sternenseemann ];
=======
  meta = with lib; {
    homepage = "http://gopher.quux.org:70/devel/gopher";
    description = "Ncurses gopher client";
    platforms = platforms.linux; # clang doesn't like local regex.h
    license = licenses.gpl2;
    maintainers = with maintainers; [ sternenseemann ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
