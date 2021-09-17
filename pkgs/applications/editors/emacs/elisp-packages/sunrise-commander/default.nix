{ lib
, trivialBuild
, fetchFromGitHub
, emacs
}:

trivialBuild rec {
  pname = "sunrise-commander";
  version = "0.0.0+unstable=2021-07-22";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "7662f635c372224e2356d745185db1e718fb7ee4";
    hash = "sha256-NYUqJ2rDidVchX2B0+ApNbQeZFxxCnKRYXb6Ia+NzLI=";
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
