{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "medical-docs";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package to assist in medical Documentation";
    homepage = "https://github.com/wressl/medical-docs";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
