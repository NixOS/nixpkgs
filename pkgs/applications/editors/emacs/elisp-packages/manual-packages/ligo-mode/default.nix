{ lib
, melpaBuild
, fetchFromGitLab
, writeText
, unstableGitUpdater
}:

let
  pname = "ligo-mode";
  version = "1.7.1-unstable-2024-06-28";
  commit = "a62dff504867c4c4d9e0047114568a6e6b1eb291";
in
melpaBuild {
  inherit pname version commit;

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = commit;
    hash = "sha256-YnI2sZCE5rStWsQYY/D+Am1rep4UdK28rlmPMmJeY50=";
  };

  packageRequires = [ ];

  buildInputs = [ ];

  checkInputs = [ ];

  recipe = writeText "recipe" ''
    (ligo-mode :fetcher gitlab
               :repo "ligolang/ligo"
               :files ("tools/emacs/ligo-mode.el"))
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Major mode for editing LIGO source code";
    homepage = "https://gitlab.com/ligolang/ligo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
