{ lib
, melpaBuild
, fetchFromGitHub
, consult
, embark
, forge
, gh
, markdown-mode
, writeText
, unstableGitUpdater
}:

let
  commit = "3a07139a1f7e38b959ce177a122c8f47c401d7fa";
in
melpaBuild {
  pname = "consult-gh";
  version = "0.12-unstable-2024-04-23";

  inherit commit;

  src = fetchFromGitHub {
    owner = "armindarvish";
    repo = "consult-gh";
    rev = commit;
    hash = "sha256-BZloG5RuQzC2RwCfvqPPhGcbsCabQWBnRHdU62rwNdo=";
  };

  packageRequires = [
    consult
    embark
    forge
    gh
    markdown-mode
  ];

  recipe = writeText "recipe" ''
    (consult-gh
      :repo "armindarvish/consult-gh"
      :fetcher github
      :files ("consult-gh-embark.el" "consult-gh-forge.el" "consult-gh.el"))
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/armindarvish/consult-gh";
    description = "GitHub CLI client inside GNU Emacs using Consult";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
