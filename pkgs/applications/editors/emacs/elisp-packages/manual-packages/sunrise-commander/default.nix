{ lib
, fetchFromGitHub
, melpaBuild
, writeText
}:

let
  argset = {
    pname = "sunrise-commander";
    ename = "sunrise";
    version = "20210924.1620";

    src = fetchFromGitHub {
      owner = "sunrise-commander";
      repo = "sunrise-commander";
      rev = "16e6df7e86c7a383fb4400fae94af32baf9cb24e";
      hash = "sha256-D36qiRi5OTZrBtJ/bD/javAWizZ8NLlC/YP4rdLCSsw=";
    };

    commit = argset.src.rev;

    outputs = [ "out" "doc" ];

    recipe = writeText "recipe" ''
      (sunrise
       :repo "sunrise-commander/sunrise-commander"
       :fetcher github)
    '';

    postInstall = ''
      install -Dm644 ${argset.src}/README.md -t $doc/share/doc/emacs-sunrise-${argset.version}/
    '';

    meta = {
      homepage = "https://github.com/sunrise-commander/sunrise-commander/";
      description = "Orthodox (two-pane) file manager for Emacs";
      license = lib.licenses.gpl3Plus;
      maintainers = [ lib.maintainers.AndersonTorres ];
    };
  };
in
melpaBuld argset
