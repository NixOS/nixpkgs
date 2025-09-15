{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "uuid";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "13eb7d6d7d242bbadfb43ed4284d6b46ba63ce11";
    hash = "sha256-r0V24FeBiS8LRzbzMjLKJqitpoiOWnuynGMahmDYe3s=";
  };

  meta = {
    description = "Inserts a newly-generated UUIDv4, lowercase, uppercase, even non-dash.";
    homepage = "https://github.com/Arylen/espanso-uuid";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
