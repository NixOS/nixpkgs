{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation rec {
  version = "1.0.18";
  pname = "mdp";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = version;
    sha256 = "sha256-7ltqnvNzdr+sJiiiCQpp25dzhOrcUCOAgMTt1RIgVTw=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs = [ ncurses ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/visit1985/mdp";
    description = "Command-line based markdown presentation tool";
    maintainers = with lib.maintainers; [ matthiasbeyer ];
    license = lib.licenses.gpl3;
    platforms = with lib.platforms; unix;
=======
  meta = with lib; {
    homepage = "https://github.com/visit1985/mdp";
    description = "Command-line based markdown presentation tool";
    maintainers = with maintainers; [ matthiasbeyer ];
    license = licenses.gpl3;
    platforms = with platforms; unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "mdp";
  };
}
