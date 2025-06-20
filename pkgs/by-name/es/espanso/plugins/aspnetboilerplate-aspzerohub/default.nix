{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "aspnetboilerplate-aspzerohub";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package to include aspnetboilerplate and aspnet zero shortcut code generation in espanso.";
    homepage = "https://github.com/canmavi/aspboilerplate-aspzerohub";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
