{
  lib,
  melpaBuild,
  fetchFromGitLab,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "ligo-mode";
  version = "1.7.1-unstable-2024-07-17";

  src = fetchFromGitLab {
    owner = "ligolang";
    repo = "ligo";
    rev = "09afc3ff3dd9c88b2dfbc563278a78a099b39902";
    hash = "sha256-AX0zZljZPrfBlpdgCNuiq0JaYpHcVBdHHZ9jM31LlQs=";
  };

  files = ''("tools/emacs/ligo-mode.el")'';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Major mode for editing LIGO source code";
    homepage = "https://gitlab.com/ligolang/ligo";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
