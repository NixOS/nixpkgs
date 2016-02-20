{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.5";
  name = "mdp-${version}";

  src = fetchurl {
    url = "https://github.com/visit1985/mdp/archive/${version}.tar.gz";
    sha256 = "0ckd9k5571zc7pzxdx84gv8k103d5qp49f2i477a395fy2pnq4m8";
  };

  makeFlags = "PREFIX=$(out)";

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.gpl3;
  };
}
