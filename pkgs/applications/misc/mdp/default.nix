{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation {
  name = "mdp-0.93";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = "09d6bd1a8a33fac75a999f0822ec10cb77fbc072";
    sha256 = "0ksa0zqzv1yb8nspxp2vww7bp9y99pcma1vx3cixd3qb5y5ljn1n";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ ncurses ];

  meta = {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
  };
}
