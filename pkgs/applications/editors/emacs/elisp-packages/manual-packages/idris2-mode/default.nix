{
  lib,
  trivialBuild,
  fetchFromGitHub,
  emacs,
  prop-menu,
}:

trivialBuild rec {
  pname = "idris2-mode";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "idris-community";
    repo = pname;
    rev = version;
    hash = "sha256-rTeVjkAw44Q35vjaERs4uoZRJ6XR3FKplEUCVPHhY7Q=";
  };

  buildInputs = propagatedUserEnvPkgs;

  propagatedUserEnvPkgs = [
    prop-menu
  ];

  meta = with lib; {
    homepage = "https://github.com/idris-community/idris2-mode";
    description = "This is an emacs mode for editing Idris 2 code.";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ wuyoli ];
    inherit (emacs.meta) platforms;
  };
}
