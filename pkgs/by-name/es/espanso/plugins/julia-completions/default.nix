{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "julia-completions";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Julia latex and emoji completions for espanso";
    homepage = "https://github.com/lukeburns/espanso-julia-completions";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
