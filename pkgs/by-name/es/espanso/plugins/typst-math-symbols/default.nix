{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "typst-math-symbols";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "13eb7d6d7d242bbadfb43ed4284d6b46ba63ce11";
    hash = "sha256-r0V24FeBiS8LRzbzMjLKJqitpoiOWnuynGMahmDYe3s=";
  };

  meta = {
    description = "All Typst math symbols to Unicode";
    homepage = "https://typst.app/docs/reference/symbols/sym/";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
