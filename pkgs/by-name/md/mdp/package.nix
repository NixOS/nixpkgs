{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "1.0.19";
  pname = "mdp";

  src = fetchFromGitHub {
    owner = "visit1985";
    repo = "mdp";
    rev = finalAttrs.version;
    sha256 = "sha256-qMxuhq6LqS1o5TqQAbmGYgISWzmcocaHEYTASUN6S2c=";
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
})
