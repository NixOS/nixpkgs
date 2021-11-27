{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.pre+date=2021-10-26";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "bqn-mode";
    rev = "89d6928d0653518c97bcb06ae156f8b1de1b8768";
    sha256 = "sha256-BWBZD/VJ0GrnFoZ6iJnGq8nv3D5uHw4Nlwsr+rR2214=";
  };

  meta = with lib; {
    description = "Emacs mode for BQN programming language";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sternenseemann AndersonTorres ];
  };
}
