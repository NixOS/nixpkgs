{
  lib,
  fetchFromGitHub,
  melpaBuild,
  prop-menu,
  gitUpdater,
}:

let
  version = "1.1";
in
melpaBuild {
  pname = "idris2-mode";
  inherit version;

  src = fetchFromGitHub {
    owner = "idris-community";
    repo = "idris2-mode";
    tag = version;
    hash = "sha256-rTeVjkAw44Q35vjaERs4uoZRJ6XR3FKplEUCVPHhY7Q=";
  };

  packageRequires = [
    prop-menu
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    homepage = "https://github.com/idris-community/idris2-mode";
    description = "Emacs mode for editing Idris 2 code";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ wuyoli ];
  };
}
