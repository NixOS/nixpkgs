{ trivialBuild
, lib
, fetchFromGitHub
, curl
, plz
, cl-lib
, ts
}:

trivialBuild {
  pname = "ement";
  version = "unstable-2021-09-08";

  packageRequires = [
    plz
    cl-lib
    ts
  ];

  src = fetchFromGitHub {
    owner = "alphapapa";
    repo = "ement.el";
    rev = "468aa9b0526aaa054f059c63797aa3d9ea13611d";
    sha256 = "sha256-0FCAu253iTSf9qcsmoJxKlzfd5eYc8eJXUxG6+0eg/I=";
  };

  meta = {
    description = "Ement.el is a Matrix client for Emacs";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}
