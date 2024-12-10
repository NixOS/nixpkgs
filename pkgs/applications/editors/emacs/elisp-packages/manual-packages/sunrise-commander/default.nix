{
  lib,
  trivialBuild,
  fetchFromGitHub,
  emacs,
}:

trivialBuild {
  pname = "sunrise-commander";
  version = "unstable=2021-09-27";

  src = fetchFromGitHub {
    owner = "sunrise-commander";
    repo = "sunrise-commander";
    rev = "16e6df7e86c7a383fb4400fae94af32baf9cb24e";
    hash = "sha256-D36qiRi5OTZrBtJ/bD/javAWizZ8NLlC/YP4rdLCSsw=";
  };

  buildInputs = [
    emacs
  ];

  meta = {
    homepage = "https://github.com/sunrise-commander/sunrise-commander/";
    description = "Orthodox (two-pane) file manager for Emacs";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
