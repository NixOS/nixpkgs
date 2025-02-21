{
  lib,
  consult,
  embark-consult,
  fetchFromGitHub,
  forge,
  gh,
  markdown-mode,
  melpaBuild,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "consult-gh";
  version = "1.0-unstable-2024-08-24";

  src = fetchFromGitHub {
    owner = "armindarvish";
    repo = "consult-gh";
    rev = "b1d85d179438e4b6469e1b78906a7dde8f07c822";
    hash = "sha256-VmxuXvO0nl0h9IKU+XWfjW90KG/1B+qHoOVhvYJ8XTs=";
  };

  packageRequires = [
    consult
    embark-consult
    forge
    markdown-mode
  ];

  propagatedUserEnvPkgs = [ gh ];

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/armindarvish/consult-gh";
    description = "GitHub CLI client inside GNU Emacs using Consult";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
