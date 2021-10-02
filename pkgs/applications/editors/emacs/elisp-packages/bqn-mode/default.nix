{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.0.0+unstable=2021-09-27";

  src = fetchFromGitHub {
    owner = "AndersonTorres";
    repo = "bqn-mode";
    rev = "5bdc713ade78f11d756231739429440552d7faf8";
    hash = "sha256-ztGHWKVgMP9N4hV9k0PY9LxqXgHxkycyF3N0eZ+jIZs=";
  };

  meta = with lib; {
    description = "Emacs mode for BQN programming language";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sternenseemann AndersonTorres ];
  };
}
