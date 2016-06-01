{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.6";
  name = "mdp-${version}";

  src = fetchurl {
    url = "https://github.com/visit1985/mdp/archive/${version}.tar.gz";
    sha256 = "1m6qbqr9kfj27qf27gkgqr1jpf7z0xym71w61pnjwsmcryp0db19";
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
