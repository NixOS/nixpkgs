{ lib
, trivialBuild
, fetchFromGitHub
, color-theme
}:

trivialBuild {
  pname = "color-theme-solarized";
  version = "0.pre+unstable=2017-10-24";

  src = fetchFromGitHub {
    owner = "sellout";
    repo = "emacs-color-theme-solarized";
    rev = "f3ca8902ea056fb8e46cb09f09c96294e31cd4ee";
    hash = "sha256-oxX0lo6sxotEiR3nPrKPE9H01HKB3ohB/p8eEHFTp5k=";
  };

  packageRequires = [ color-theme ];

  meta = with lib; {
    homepage = "http://ethanschoonover.com/solarized";
    description = "Precision colors for machines and people; Emacs implementation";
    license = licenses.mit;
    maintainers = with maintainers; [ samuelrivas AndersonTorres ];
  };
}
