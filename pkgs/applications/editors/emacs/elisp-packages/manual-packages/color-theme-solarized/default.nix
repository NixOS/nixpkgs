{ lib
, color-theme
, fetchFromGitHub
, melpaBuild
, writeText
}:

let
  argset = {
    pname = "color-theme-solarized";
    ename = "color-theme-solarized";
    version = "20230209.837";

    src = fetchFromGitHub {
      owner = "sellout";
      repo = "emacs-color-theme-solarized";
      rev = "b186e5d62d0b83cbf5cf38f7eb7a199dea9a3ee3";
      hash = "sha256-7E8r56dzfD06tsQEnqU5mWSbwz9x9QPbzken2J/fhlg=";
    };

    packageRequires = [
      color-theme
    ];

    commit = argset.src.rev;

    recipe = writeText "recipe" ''
      (color-theme-solarized
       :repo "sellout/emacs-color-theme-solarized"
       :fetcher github)
    '';

    meta =  {
      homepage = "http://ethanschoonover.com/solarized";
      description = "Precision colors for machines and people; Emacs implementation";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ AndersonTorres ];
    };
  };
in
melpaBuild argset
