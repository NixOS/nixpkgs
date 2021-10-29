{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.pre+unstable=2021-10-26";

  src = fetchFromGitHub {
    owner = "AndersonTorres";
    repo = "bqn-mode";
    rev = "89d6928d0653518c97bcb06ae156f8b1de1b8768";
    sha256 = "0pnvfssglaqbjw6hw7vf7vffzjdbqscqhyl62vknml29yl7mjq05";
  };

  meta = with lib; {
    description = "Emacs mode for BQN programming language";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sternenseemann AndersonTorres ];
  };
}
