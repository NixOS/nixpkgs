{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "actually-all-emojis";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "An updated package providing all v.15 emojis - fetched from unicode.org";
    homepage = "https://github.com/jobiewong/espanso-emojis";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
