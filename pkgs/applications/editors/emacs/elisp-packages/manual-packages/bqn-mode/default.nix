{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.pre+date=2022-09-14";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "bqn-mode";
    rev = "3e3d4758c0054b35f047bf6d9e03b1bea425d013";
    hash = "sha256:0pz3m4jp4dn8bsmc9n51sxwdk6g52mxb6y6f6a4g4hggb35shy2a";
  };

  meta = with lib; {
    description = "Emacs mode for BQN programming language";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sternenseemann AndersonTorres ];
  };
}
