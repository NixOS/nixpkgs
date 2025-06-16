{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "foreign-greetings";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "🌐 Espanso package to easy say Hi in different languages";
    homepage = "https://github.com/kopach/espanso-package-foreign-greetings#readme";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
