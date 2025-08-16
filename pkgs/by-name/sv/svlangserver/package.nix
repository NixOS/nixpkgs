{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "svlangserver";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "imc-trading";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CkcKyC2W6NBvxkwYDVHpBF5T2NMiiDVVwR1mftEks54=";
  };

  npmDepsHash = "sha256-XovXh3weLh7xO96chlYwkqUnzganjLmKcUsAdBhA060=";

  npmPackFlags = [ "--ignore-scripts" ];

  meta = with lib; {
    description = "A language server for systemverilog that has been tested to work with coc.nvim, VSCode, Sublime Text 4, emacs, and Neovim.";
    homepage = "https://github.com/imc-trading/svlangserver";
    license = licenses.mit;
    maintainers = with maintainers; [ imadnyc ];
  };
}

