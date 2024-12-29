{
  lib,
  fetchFromGitHub,
  melpaBuild,
  prop-menu,
}:

melpaBuild rec {
  pname = "idris2-mode";
  version = "1.1";

  src = fetchFromGitHub {
    owner = "idris-community";
    repo = "idris2-mode";
    rev = version;
    hash = "sha256-rTeVjkAw44Q35vjaERs4uoZRJ6XR3FKplEUCVPHhY7Q=";
  };

  packageRequires = [
    prop-menu
  ];

  meta = {
    homepage = "https://github.com/idris-community/idris2-mode";
    description = "Emacs mode for editing Idris 2 code";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wuyoli ];
  };
}
