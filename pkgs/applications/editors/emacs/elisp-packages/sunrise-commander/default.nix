{ lib
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "sunrise-commander";
  version = "0.pre+unstable=2021-09-27";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "16e6df7e86c7a383fb4400fae94af32baf9cb24e";
    hash = "sha256-D36qiRi5OTZrBtJ/bD/javAWizZ8NLlC/YP4rdLCSsw=";
  };

  buildInputs = [
    emacs
  ];

  meta = with lib; {
    homepage = "https://github.com/sunrise-commander/sunrise-commander/";
    description = "Orthodox (two-pane) file manager for Emacs";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.all;
  };
}
