{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "quotes";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "13eb7d6d7d242bbadfb43ed4284d6b46ba63ce11";
    hash = "sha256-r0V24FeBiS8LRzbzMjLKJqitpoiOWnuynGMahmDYe3s=";
  };

  meta = {
    description = "Include different quotations and quotation-related characters to espanso.";
    homepage = "https://github.com/WhistlingZephyr/espanso-package-quotes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
