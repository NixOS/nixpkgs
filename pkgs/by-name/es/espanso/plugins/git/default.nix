{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "git";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package of the most common and important Git commands. Become faster with the Git CLI.";
    homepage = "https://github.com/angelorpt/espanso-git";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
