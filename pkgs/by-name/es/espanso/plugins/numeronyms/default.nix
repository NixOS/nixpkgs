{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "numeronyms";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "Commonly used numeronyms";
    homepage = "https://github.com/omrilotan/espanso-package-numeronyms";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
