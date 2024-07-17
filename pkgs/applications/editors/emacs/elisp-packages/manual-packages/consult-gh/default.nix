{
  lib,
  melpaBuild,
  fetchFromGitHub,
  consult,
  embark,
  forge,
  gh,
  markdown-mode,
  writeText,
  unstableGitUpdater,
}:

let
  commit = "1fe876d9552b6ec6af257a4299a34eca99b40539";
in
melpaBuild {
  pname = "consult-gh";
  version = "20230706.438";

  inherit commit;

  src = fetchFromGitHub {
    owner = "armindarvish";
    repo = "consult-gh";
    rev = commit;
    hash = "sha256-bi+qlNvNMXbS4cXbXt01txwD2NAyAqJGNKeOtdtj7tg=";
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
    description = "A GitHub CLI client inside GNU Emacs using Consult";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
