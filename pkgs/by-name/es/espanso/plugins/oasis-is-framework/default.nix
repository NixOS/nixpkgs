{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "oasis-is-framework";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "OASIS-IS Generative AI mega-prompt framework for \"conversations\" with Generative AI.  This is a starter prompt that gets the information you need to added to your initial prompt.";
    homepage = "https://github.com/Ryfter/oasis-is-framework/";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
