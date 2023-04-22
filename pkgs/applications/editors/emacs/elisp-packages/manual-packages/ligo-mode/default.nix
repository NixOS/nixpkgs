{ lib
, melpaBuild
, fetchFromGitLab
, writeText
, unstableGitUpdater
}:

let
  pname = "ligo-mode";
  version = "20230302.1616";
  commit = "d1073474efc9e0a020a4bcdf5e0c12a217265a3a";
in
melpaBuild {
  inherit pname version commit;

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = commit;
    hash = "sha256-wz9DF9mqi8WUt1Ebd+ueUTA314rKkdbjmoWF8cKuS8I=";
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

  meta = with lib; {
    description = "A blazingly fast LSP client for Emacs";
    homepage = "https://github.com/manateelazycat/lsp-bridge";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
  };
}
