{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

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

  meta = {
    homepage = "https://github.com/visit1985/mdp";
    description = "Command-line based markdown presentation tool";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
    mainProgram = "mdp";
  };
}
