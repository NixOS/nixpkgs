{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "html-entities-unicode";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "13eb7d6d7d242bbadfb43ed4284d6b46ba63ce11";
    hash = "sha256-r0V24FeBiS8LRzbzMjLKJqitpoiOWnuynGMahmDYe3s=";
  };

  meta = {
    description = "A character entity decoder, converting HTML/XML named character entities into their corresponding Unicode characters.";
    homepage = "https://github.com/kijeEnki";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
