{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.13";
  name = "mdp-${version}";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "0snmglsmgfavgv6cnlb0j54sr0paf570ajpwk1b3g81v078hz2aq";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ ncurses ];

  meta = with stdenv.lib; {
    homepage = https://github.com/visit1985/mdp;
    description = "A command-line based markdown presentation tool";
    maintainers = with maintainers; [ vrthra ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
  };
}
