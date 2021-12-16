{ lib
, trivialBuild
, fetchFromGitHub
}:

trivialBuild {
  pname = "bqn-mode";
  version = "0.pre+date=2021-12-03";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = "bqn-mode";
    rev = "38fba1193e0d1101f3b90bd76e419c011651ad6f";
    sha256 = "0fdfz3kmrdgmx2i6fgrrj1cvapvrgnc3ahnwx3aayrpl1f091439";
  };

  meta = with lib; {
    description = "Emacs mode for BQN programming language";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ sternenseemann AndersonTorres ];
  };
}
