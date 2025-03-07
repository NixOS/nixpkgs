{ sfml, fetchFromGitHub, ... }:
sfml.overrideAttrs {
  version = "2.6.2";

  src = fetchFromGitHub {
    owner = "SFML";
    repo = "SFML";
    tag = "2.6.2";
    hash = "sha256-m8FVXM56qjuRKRmkcEcRI8v6IpaJxskoUQ+sNsR1EhM=";
  };
}
