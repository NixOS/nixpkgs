{
  lib,
  consult,
  embark,
  fetchFromGitHub,
  forge,
  gh,
  markdown-mode,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "consult-gh";
  version = "0.12-unstable-2024-04-23";

  src = fetchFromGitHub {
    owner = "armindarvish";
    repo = "consult-gh";
    rev = "3a07139a1f7e38b959ce177a122c8f47c401d7fa";
    hash = "sha256-BZloG5RuQzC2RwCfvqPPhGcbsCabQWBnRHdU62rwNdo=";
  };

  packageRequires = [
    consult
    embark
    forge
    markdown-mode
  ];

  propagatedUserEnvPkgs = [ gh ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/armindarvish/consult-gh";
    description = "GitHub CLI client inside GNU Emacs using Consult";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
