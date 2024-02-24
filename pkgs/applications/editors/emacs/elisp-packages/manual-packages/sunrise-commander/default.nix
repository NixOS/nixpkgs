{ lib
, fetchFromGitHub
, melpaBuild
, writeMelpaRecipe
}:

let
  pname = "sunrise-commander";
  version = "20210924.1620";

  src = fetchFromGitHub {
    owner = "sunrise-commander";
    repo = "sunrise-commander";
    rev = "16e6df7e86c7a383fb4400fae94af32baf9cb24e";
    hash = "sha256-D36qiRi5OTZrBtJ/bD/javAWizZ8NLlC/YP4rdLCSsw=";
  };
in
melpaBuild {
  inherit pname version src;

  commit = src.rev;

  outputs = [ "out" "doc" ];

  recipe = writeMelpaRecipe {
    package-name = "sunrise";
    fetcher = "github";
    repo = "sunrise-commander/sunrise-commander";
  };

  postInstall = ''
    install -Dm644 ${src}/README.md -t $doc/share/doc/emacs-sunrise-${version}/
  '';

  meta = {
    homepage = "https://github.com/sunrise-commander/sunrise-commander/";
    description = "Orthodox (two-pane) file manager for Emacs";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.AndersonTorres ];
    platforms = lib.platforms.all;
  };
}
