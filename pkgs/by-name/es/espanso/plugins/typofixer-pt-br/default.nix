{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "typofixer-pt-br";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "13eb7d6d7d242bbadfb43ed4284d6b46ba63ce11";
    hash = "sha256-r0V24FeBiS8LRzbzMjLKJqitpoiOWnuynGMahmDYe3s=";
  };

  meta = {
    description = "A package for correcting common mistakes when writing some Brazilian Portuguese words.";
    homepage = "https://github.com/rapha-au/typofixer-pt-br";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
