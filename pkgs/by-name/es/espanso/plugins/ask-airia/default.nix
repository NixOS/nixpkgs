{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "ask-airia";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "13eb7d6d7d242bbadfb43ed4284d6b46ba63ce11";
    hash = "sha256-r0V24FeBiS8LRzbzMjLKJqitpoiOWnuynGMahmDYe3s=";
  };

  meta = {
    description = "An Espanso package that enables users to quickly send prompts to Airia Agents.";
    homepage = "https://github.com/carlescarles/ask-airia/edit/main/README.md";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
