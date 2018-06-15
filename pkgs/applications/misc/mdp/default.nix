{ stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.12";
  name = "mdp-${version}";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "04izj9i9rxmgswjh2iawqs6qglfv44zfv042smmcvfh1pm43361i";
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
