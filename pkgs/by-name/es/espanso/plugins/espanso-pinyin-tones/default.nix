{
  lib,
  fetchFromGitHub,
  mkEspansoPlugin,
}:
mkEspansoPlugin {
  pname = "espanso-pinyin-tones";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "espanso";
    repo = "hub";
    rev = "d62bde95fc6f6cf90d4c23ee243922037c053def";
    hash = "sha256-1cPtknrIi+9uTQt0pMaOBnY3C1GAGXPAA4fIgBh5Wgs=";
  };

  meta = {
    description = "A package for typing Chinese pinyin tones";
    homepage = "https://github.com/IdiosApps/espanso-pinyin-tones";
    maintainers = with lib.maintainers; [ delafthi ];
  };
}
