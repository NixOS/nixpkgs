{ lib, stdenv, fetchFromGitHub, ncurses }:

stdenv.mkDerivation rec {
  version = "1.0.15";
  pname = "mdp";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "1m9a0vvyw2m55cn7zcq011vrjkiaj5a3g5g6f2dpq953gyi7gff9";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ ncurses ];

  meta = with lib; {
    homepage = "https://github.com/visit1985/mdp";
    description = "Command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer vrthra ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
    mainProgram = "mdp";
  };
}
