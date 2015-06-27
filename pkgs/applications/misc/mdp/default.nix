{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "mdp-${version}";

  src = fetchurl {
    url = "https://github.com/visit1985/mdp/archive/${version}.tar.gz";
    sha256 = "1xkmzcwa5ml1xfv92brwirnm00a44jkj7wpfimxbny98zgmad8vn";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ ncurses ];

  meta = {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
  };
}
