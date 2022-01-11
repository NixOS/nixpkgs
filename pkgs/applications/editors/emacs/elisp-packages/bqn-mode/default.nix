{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.pre+date=2022-01-07";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "bqn-mode";
    rev = "86ef8b4d32d272b2765cd4a6e6e0b70a4f3e99a2";
    hash = "sha256-6ygV/iNzzpZ77w+Dh/snHAzUxrbfaU9TxuNOtJK6pNQ=";
  };

  meta = with lib; {
    description = "Emacs mode for BQN programming language";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sternenseemann AndersonTorres ];
  };
}
